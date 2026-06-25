import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { createServer, type IncomingMessage, type ServerResponse } from "node:http";
import { spawn, spawnSync } from "node:child_process";
import { createHash } from "node:crypto";
import { mkdirSync, readFileSync, writeFileSync, existsSync } from "node:fs";
import { join } from "node:path";
import { parsePatchFiles } from "@pierre/diffs";
import { preloadFileDiff } from "@pierre/diffs/ssr";
import { marked } from "marked";

type Comment = {
  id: string;
  file: string;
  line: number;
  side: "new" | "old" | "unknown";
  text: string;
  createdAt: string;
  resolved?: boolean;
};

type ReviewState = {
  cwd: string;
  target: string;
  mode: string;
  diff: string;
  diffHash: string;
  renderedDiff: string;
  summary: string;
  stats: DiffStats;
  comments: Comment[];
  updatedAt: string;
};

type DiffStats = { files: number; additions: number; deletions: number; fileNames: string[] };

const SUMMARY_STATUS_WIDGET_ID = "code-review-summary-status";

let server: ReturnType<typeof createServer> | undefined;
let port = 0;
let poller: NodeJS.Timeout | undefined;
let state: ReviewState | undefined;
let commentsPath = "";
let clients: ServerResponse[] = [];
let summaryRunId = 0;

export default function (pi: ExtensionAPI) {
  pi.registerCommand("super-review", {
    description: "Open an HTML super review for all uncommitted changes or a git target, e.g. /super-review against master",
    handler: async (args, ctx) => {
      const target = args || "uncommitted";
      const result = await startReview(ctx, target, true);
      ctx.ui.notify(`Review open: ${result.url}`, "info");
      generateSummaryInBackground(ctx, target);
    }, 
  });

  pi.registerTool({
    name: "review_start",
    label: "Start Code Review",
    description: "Open/update the HTML review view for all uncommitted changes or a target such as 'against master'.",
    parameters: Type.Object({ target: Type.Optional(Type.String()) }),
    promptSnippet: "Open an HTML git diff review UI and keep it live for line comments.",
    async execute(_id, params, _signal, _onUpdate, ctx) {
      const target = params.target || "uncommitted";
      const result = await startReview(ctx, target, true);
      generateSummaryInBackground(ctx, target);
      return textResult(`Review open: ${result.url}\nMode: ${state?.mode}\nTarget: ${state?.target}\nSummary is generating in a separate pi process.`);
    },
  });

  pi.registerTool({
    name: "review_diff_snapshot",
    label: "Read Review Diff",
    description: "Read the current review diff and stats so the agent can summarize it.",
    parameters: Type.Object({ maxChars: Type.Optional(Type.Number()) }),
    async execute(_id, params, _signal, _onUpdate, ctx) {
      if (!state) await ensureState(ctx, "uncommitted");
      const max = params.maxChars ?? 60000;
      const diff = state!.diff.length > max ? state!.diff.slice(0, max) + "\n...<truncated>" : state!.diff;
      return textResult(JSON.stringify({ mode: state!.mode, target: state!.target, stats: state!.stats, diff }, null, 2));
    },
  });

  pi.registerTool({
    name: "review_update_summary",
    label: "Update Review Summary",
    description: "Set the markdown summary shown above the diff. Mermaid code fences are rendered in the browser.",
    parameters: Type.Object({ markdown: Type.String() }),
    async execute(_id, params, _signal, _onUpdate, ctx) {
      if (!state) await ensureState(ctx, "uncommitted");
      state!.summary = params.markdown;
      await refresh(ctx, false);
      broadcast();
      return textResult("Review summary updated.");
    },
  });

  pi.registerTool({
    name: "review_get_comments",
    label: "Read Review Comments",
    description: "Read comments left in the HTML code review.",
    parameters: Type.Object({ includeResolved: Type.Optional(Type.Boolean()) }),
    async execute(_id, _params, _signal, _onUpdate, ctx) {
      if (!state) await ensureState(ctx, "uncommitted");
      const comments = state!.comments.filter((c) => _params.includeResolved || !c.resolved);
      return textResult(comments.length ? JSON.stringify(comments, null, 2) : "No review comments.");
    },
  });

  pi.registerTool({
    name: "review_resolve_comments",
    label: "Resolve Review Comments",
    description: "Mark review comments as resolved by id, or all unresolved comments.",
    parameters: Type.Object({
      ids: Type.Optional(Type.Array(Type.String())),
      all: Type.Optional(Type.Boolean()),
    }),
    async execute(_id, params, _signal, _onUpdate, ctx) {
      if (!state) await ensureState(ctx, "uncommitted");
      const ids = new Set(params.ids || []);
      let count = 0;
      for (const comment of state!.comments) {
        if (comment.resolved) continue;
        if (params.all || ids.has(comment.id)) {
          comment.resolved = true;
          count++;
        }
      }
      saveComments();
      return textResult(`Resolved ${count} comment${count === 1 ? "" : "s"}.`);
    },
  });

  pi.on("session_shutdown", async () => stop());
}

async function startReview(ctx: ExtensionContext, targetArg: string, openBrowser: boolean) {
  await ensureState(ctx, targetArg);
  if (!server) await startServer();
  await refresh(ctx, true);
  startPolling(ctx);
  const url = `http://127.0.0.1:${port}/`;
  if (openBrowser) spawnSync("open", [url], { stdio: "ignore" });
  return { url };
}

async function ensureState(ctx: ExtensionContext, targetArg: string) {
  const parsed = parseTarget(targetArg);
  commentsPath = join(ctx.cwd, ".pi", "code-review-comments.json");
  mkdirSync(join(ctx.cwd, ".pi"), { recursive: true });
  ensureCommentsIgnored(ctx.cwd);
  if (!state || state.cwd !== ctx.cwd || state.target !== parsed.target || state.mode !== parsed.mode) {
    state = {
      cwd: ctx.cwd,
      target: parsed.target,
      mode: parsed.mode,
      diff: "",
      diffHash: "",
      renderedDiff: "",
      summary: defaultSummary(),
      stats: { files: 0, additions: 0, deletions: 0, fileNames: [] },
      comments: loadComments(),
      updatedAt: new Date().toISOString(),
    };
  }
}

function parseTarget(arg: string) {
  const raw = arg.trim();
  if (!raw || /^(uncommitted|all|default)$/i.test(raw)) return { mode: "uncommitted", target: "uncommitted" };
  if (/^(staged|stage|cached)$/i.test(raw)) return { mode: "staged", target: "staged" };
  if (/^(worktree|working|unstaged)$/i.test(raw)) return { mode: "working", target: "working" };
  const target = raw.replace(/^against\s+/i, "").trim();
  return { mode: "range", target: target || "uncommitted" };
}

async function refresh(ctx: ExtensionContext, force: boolean) {
  if (!state) return;
  const diff = getDiff(state.cwd, state.mode, state.target);
  const hash = sha(diff + state.summary);
  if (!force && hash === state.diffHash) return;
  state.diff = diff;
  state.stats = getStats(state.cwd, state.mode, state.target, diff);
  state.renderedDiff = diff.trim()
    ? await renderDiff(diff)
    : emptyDiffMessage(state.cwd, state.mode, state.target);
  state.diffHash = hash;
  state.updatedAt = new Date().toISOString();
  saveComments();
}

function git(cwd: string, args: string[], maxBuffer = 100 * 1024 * 1024) {
  return spawnSync("git", args, { cwd, encoding: "utf8", maxBuffer });
}

function getDiff(cwd: string, mode: string, target: string) {
  let args: string[];
  if (mode === "uncommitted") return [git(cwd, ["diff", "HEAD", "--find-renames", "--find-copies", "--", "."]).stdout, untrackedDiff(cwd)].filter(Boolean).join("\n");
  if (mode === "staged") args = ["diff", "--cached", "--find-renames", "--find-copies", "--", "."];
  else if (mode === "working") args = ["diff", "--find-renames", "--find-copies", "--", "."];
  else args = ["diff", "--find-renames", "--find-copies", `${resolveTarget(cwd, target)}...HEAD`, "--", "."];
  let r = git(cwd, args);
  if (r.status !== 0 && mode === "range") r = git(cwd, ["diff", "--find-renames", resolveTarget(cwd, target), "--", "."]);
  return r.stdout || r.stderr || "";
}

function getStats(cwd: string, mode: string, target: string, diff: string): DiffStats {
  let args: string[];
  if (mode === "uncommitted") args = ["diff", "HEAD", "--numstat", "--"];
  else if (mode === "staged") args = ["diff", "--cached", "--numstat", "--"];
  else if (mode === "working") args = ["diff", "--numstat", "--"];
  else args = ["diff", "--numstat", `${resolveTarget(cwd, target)}...HEAD`, "--"];
  const r = git(cwd, args, 20 * 1024 * 1024);
  const lines = (r.stdout || "").trim().split("\n").filter(Boolean);
  let additions = 0, deletions = 0;
  const fileNames: string[] = [];
  for (const line of lines) {
    const [a, d, ...name] = line.split("\t");
    additions += Number(a) || 0;
    deletions += Number(d) || 0;
    fileNames.push(name.join("\t"));
  }
  if (mode === "uncommitted") {
    for (const file of untrackedFiles(cwd)) {
      if (isBinaryFile(cwd, file)) continue;
      additions += readFileSync(join(cwd, file), "utf8").split("\n").length - 1;
      fileNames.push(file);
    }
  }
  if (!fileNames.length && diff) fileNames.push(...Array.from(diff.matchAll(/^diff --git a\/(.*?) b\/(.*?)$/gm), (m) => m[2]));
  return { files: new Set(fileNames).size, additions, deletions, fileNames: [...new Set(fileNames)] };
}

function untrackedFiles(cwd: string) {
  const r = git(cwd, ["ls-files", "--others", "--exclude-standard", "-z"], 20 * 1024 * 1024);
  return (r.stdout || "").split("\0").filter(Boolean);
}

function untrackedDiff(cwd: string) {
  return untrackedFiles(cwd).map((file) => newFileDiff(cwd, file)).filter(Boolean).join("\n");
}

function newFileDiff(cwd: string, file: string) {
  if (isBinaryFile(cwd, file)) return `diff --git a/${file} b/${file}\nnew file mode 100644\nBinary files /dev/null and b/${file} differ\n`;
  const contents = readFileSync(join(cwd, file), "utf8");
  const lines = contents.split("\n");
  if (lines.at(-1) === "") lines.pop();
  return [
    `diff --git a/${file} b/${file}`,
    "new file mode 100644",
    "index 0000000..0000000",
    "--- /dev/null",
    `+++ b/${file}`,
    `@@ -0,0 +1,${lines.length} @@`,
    ...lines.map((line) => `+${line}`),
    "",
  ].join("\n");
}

function isBinaryFile(cwd: string, file: string) {
  try { return readFileSync(join(cwd, file)).subarray(0, 8000).includes(0); } catch { return true; }
}

function resolveTarget(cwd: string, target: string) {
  const raw = target.trim();
  const candidates = raw === "origin"
    ? [upstream(cwd), originHead(cwd), "origin/main", "origin/master"].filter(Boolean) as string[]
    : raw === "master"
      ? ["master", "main", "origin/main", "origin/master", originHead(cwd)].filter(Boolean) as string[]
      : [raw];
  return candidates.find((ref) => git(cwd, ["rev-parse", "--verify", `${ref}^{commit}`], 1024 * 1024).status === 0) || raw;
}

function upstream(cwd: string) {
  const r = git(cwd, ["rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{upstream}"], 1024 * 1024);
  return r.status === 0 ? r.stdout.trim() : undefined;
}

function originHead(cwd: string) {
  const r = git(cwd, ["symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD"], 1024 * 1024);
  return r.status === 0 ? r.stdout.trim() : undefined;
}

function emptyDiffMessage(cwd: string, mode: string, target: string) {
  const working = getStats(cwd, "working", "working", getDiff(cwd, "working", "working"));
  const stagedHint = mode === "staged" && working.files > 0
    ? `<p><b>There are unstaged changes</b> (${working.files} files, <span class="add">+${working.additions}</span> <span class="del">-${working.deletions}</span>), but the default review is staged only.</p><p>Stage files, or run <code>/review working</code> / <code>review_start { target: "working" }</code>.</p>`
    : "";
  return `<div class="empty"><h2>No diff to review.</h2><p>Mode: <code>${escapeHtml(mode)}</code>, target: <code>${escapeHtml(target)}</code>.</p>${stagedHint}</div>`;
}

async function renderDiff(diff: string) {
  if (!diff.trim()) return `<div class="empty">No diff to review.</div>`;
  try {
    const patches = parsePatchFiles(diff);
    const chunks: string[] = [];
    for (const patch of patches) {
      for (const file of patch.files) {
        const rendered = await preloadFileDiff({
          fileDiff: file,
          options: { diffStyle: "unified", diffIndicators: "classic", disableBackground: false, themeType: "system", wrap: true } as any,
        });
        chunks.push(`<section class="file" data-file="${escapeAttr(file.name)}">${rendered.prerenderedHTML}</section>`);
      }
    }
    return chunks.join("\n");
  } catch (error) {
    return `<pre class="raw-diff">${escapeHtml(diff)}\n\nRender error: ${escapeHtml(String(error))}</pre>`;
  }
}

function startServer() {
  return new Promise<void>((resolve) => {
    server = createServer(async (req, res) => route(req, res));
    server.listen(0, "127.0.0.1", () => {
      port = (server!.address() as any).port;
      resolve();
    });
  });
}

async function route(req: IncomingMessage, res: ServerResponse) {
  const url = new URL(req.url || "/", `http://${req.headers.host}`);
  if (url.pathname === "/events") return sse(res);
  if (url.pathname === "/api/state") return json(res, publicState());
  if (url.pathname === "/api/comments" && req.method === "POST") return saveComment(req, res);
  if (url.pathname === "/api/comments" && req.method === "PATCH") return patchComment(req, res);
  if (url.pathname === "/") return html(res);
  res.writeHead(404).end("not found");
}

async function html(res: ServerResponse) {
  res.writeHead(200, { "content-type": "text/html; charset=utf-8" });
  res.end(await appHtml(publicState()));
}

function publicState() {
  return state || { summary: defaultSummary(), renderedDiff: "", comments: [], stats: { files: 0, additions: 0, deletions: 0, fileNames: [] }, mode: "uncommitted", target: "uncommitted", updatedAt: "" };
}

function sse(res: ServerResponse) {
  res.writeHead(200, { "content-type": "text/event-stream", "cache-control": "no-cache", connection: "keep-alive" });
  clients.push(res);
  res.write(`data: ${JSON.stringify({ type: "ready" })}\n\n`);
  res.on("close", () => clients = clients.filter((c) => c !== res));
}

function broadcast() {
  const payload = `data: ${JSON.stringify({ type: "update" })}\n\n`;
  for (const client of clients) client.write(payload);
}

async function saveComment(req: IncomingMessage, res: ServerResponse) {
  const body = await readBody(req);
  const comment: Comment = { id: sha(Date.now() + JSON.stringify(body)).slice(0, 12), file: body.file, line: Number(body.line), side: body.side || "unknown", text: body.text, createdAt: new Date().toISOString() };
  state?.comments.push(comment);
  saveComments();
  json(res, comment);
}

async function patchComment(req: IncomingMessage, res: ServerResponse) {
  const body = await readBody(req);
  const comment = state?.comments.find((c) => c.id === body.id);
  if (comment) Object.assign(comment, body.patch || {});
  saveComments();
  json(res, comment || {});
}

function readBody(req: IncomingMessage) {
  return new Promise<any>((resolve) => {
    let body = "";
    req.on("data", (c) => body += c);
    req.on("end", () => resolve(body ? JSON.parse(body) : {}));
  });
}

function json(res: ServerResponse, data: unknown) {
  res.writeHead(200, { "content-type": "application/json" });
  res.end(JSON.stringify(data));
}

function startPolling(ctx: ExtensionContext) {
  if (poller) return;
  poller = setInterval(async () => {
    if (!state) return;
    const before = state.diffHash;
    await refresh(ctx, false);
    if (state.diffHash !== before) broadcast();
  }, 2000);
}

function stop(ctx?: ExtensionContext) {
  if (poller) clearInterval(poller);
  poller = undefined;
  for (const client of clients) client.end();
  clients = [];
  server?.close();
  server = undefined;
  ctx?.ui.setWidget(SUMMARY_STATUS_WIDGET_ID, undefined);
}

function loadComments(): Comment[] {
  try { return existsSync(commentsPath) ? JSON.parse(readFileSync(commentsPath, "utf8")) : []; } catch { return []; }
}

function ensureCommentsIgnored(cwd: string) {
  const exclude = join(cwd, ".git", "info", "exclude");
  if (!existsSync(exclude)) return;
  const line = ".pi/code-review-comments.json";
  const current = readFileSync(exclude, "utf8");
  if (!current.split(/\r?\n/).includes(line)) writeFileSync(exclude, `${current.trimEnd()}\n${line}\n`);
}

function saveComments() {
  if (commentsPath && state) writeFileSync(commentsPath, JSON.stringify(state.comments, null, 2));
}

async function appHtml(data: any) {
  return template()
    .replace("{{STYLE}}", style())
    .replace("{{MODE}}", escapeHtml(data.mode))
    .replace("{{TARGET}}", escapeHtml(data.target))
    .replace("{{UPDATED_AT}}", escapeHtml(data.updatedAt || ""))
    .replace("{{FILES}}", String(data.stats.files))
    .replace("{{ADDITIONS}}", String(data.stats.additions))
    .replace("{{DELETIONS}}", String(data.stats.deletions))
    .replace("{{SUMMARY}}", await markdown(data.summary))
    .replace("{{DIFF}}", data.renderedDiff)
    .replace("{{CLIENT_SCRIPT}}", clientScript(JSON.stringify(data.comments || [])));
}

function template() {
  return readFileSync(new URL("./view.html", import.meta.url), "utf8");
}

function style() {
  return readFileSync(new URL("./style.css", import.meta.url), "utf8");
}

function clientScript(initialComments: string) {
  return `let comments=${initialComments};
const es=new EventSource('/events');
es.onmessage=async e=>{const m=JSON.parse(e.data); if(m.type==='update') location.reload();};

function fileFor(el){return el.closest('.file')?.dataset.file||'unknown'}
function lineNumberFor(el){return el.dataset.line||el.dataset.columnNumber||el.getAttribute('data-line')||el.getAttribute('data-column-number')}
function codeLineFor(el){const file=el.closest('.file'); const line=lineNumberFor(el); return file?.querySelector('[data-line="'+line+'"]')}
function sideFor(el){const line=codeLineFor(el)||el; const t=line.dataset.lineType||''; return t.includes('deletion')?'old':t.includes('addition')?'new':'unknown'}

function renderComments(){renderGeneralComments();renderInlineComments();}
function renderGeneralComments(){
  const box=document.querySelector('#general-comments');
  if(!box) return;
  const general=comments.filter(x=>!x.resolved&&x.file==='__general__');
  box.innerHTML=general.map(c=>'<div class="general-comment"><button data-resolve="'+c.id+'" title="Resolve">✓</button><p>'+escapeHtml(c.text)+'</p></div>').join('');
  box.querySelectorAll('[data-resolve]').forEach(btn=>btn.onclick=async()=>{
    const id=btn.dataset.resolve;
    await fetch('/api/comments',{method:'PATCH',headers:{'content-type':'application/json'},body:JSON.stringify({id,patch:{resolved:true}})});
    comments=comments.map(x=>x.id===id?{...x,resolved:true}:x);
    renderComments();
  });
}
function renderInlineComments(){
  document.querySelectorAll('.inline-comment').forEach(n=>n.remove());
  for(const c of comments.filter(x=>!x.resolved&&x.file!=='__general__')){
    const file=[...document.querySelectorAll('.file')].find(f=>f.dataset.file===c.file);
    const line=file?.querySelector('[data-line="'+c.line+'"]');
    if(!line) continue;
    const note=document.createElement('div');
    note.className='inline-comment';
    note.innerHTML='<button data-resolve="'+c.id+'" title="Resolve">✓</button><b>💬 '+escapeHtml(c.file)+':'+c.line+'</b><p>'+escapeHtml(c.text)+'</p>';
    note.querySelector('[data-resolve]').onclick=async()=>{
      await fetch('/api/comments',{method:'PATCH',headers:{'content-type':'application/json'},body:JSON.stringify({id:c.id,patch:{resolved:true}})});
      comments=comments.map(x=>x.id===c.id?{...x,resolved:true}:x);
      renderComments();
    };
    line.after(note);
  }
}

function openCommentForm(target){
  const line=codeLineFor(target);
  if(!line) return;
  document.querySelectorAll('.inline-comment-form').forEach(n=>n.remove());
  const form=document.createElement('form');
  form.className='inline-comment-form';
  const file=fileFor(line);
  const number=lineNumberFor(line);
  form.innerHTML='<label>Comment on '+escapeHtml(file)+':'+number+'</label><textarea rows="3" autofocus></textarea><div><button type="submit">Post</button><button type="button" data-cancel>Cancel</button></div>';
  form.querySelector('[data-cancel]').onclick=()=>form.remove();
  form.onsubmit=async ev=>{
    ev.preventDefault();
    const text=form.querySelector('textarea').value.trim();
    if(!text) return;
    const r=await fetch('/api/comments',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({file,line:number,side:sideFor(line),text})});
    comments.push(await r.json());
    form.remove();
    renderComments();
  };
  line.after(form);
  form.querySelector('textarea').focus();
}

function attach(){
  const generalForm=document.querySelector('#general-comment-form');
  generalForm?.addEventListener('submit',async ev=>{
    ev.preventDefault();
    const textarea=generalForm.querySelector('textarea');
    const text=textarea.value.trim();
    if(!text) return;
    const r=await fetch('/api/comments',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({file:'__general__',line:0,side:'unknown',text})});
    comments.push(await r.json());
    textarea.value='';
    renderComments();
  });
  const diff=document.querySelector('#diff');
  diff?.addEventListener('click', ev=>{
    if(ev.target.closest('.inline-comment,.inline-comment-form')) return;
    const target=ev.target.closest('[data-line],[data-column-number]');
    if(!target) return;
    openCommentForm(target);
  });
  document.querySelectorAll('[data-line],[data-column-number]').forEach(line=>{line.title='Click to comment'});
}

function escapeHtml(s){return String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));}
renderComments(); attach();
setTimeout(async()=>{try{const mermaid=(await import('https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs')).default; mermaid.initialize({startOnLoad:true,theme:'dark',themeVariables:{background:'#0b1020',primaryColor:'#16213e',primaryTextColor:'#e5e7eb',primaryBorderColor:'#7c3aed',lineColor:'#8b5cf6',secondaryColor:'#111827',tertiaryColor:'#1f2937'}}); await mermaid.run({querySelector:'.language-mermaid'});}catch{}},50);`;
}

async function markdown(input: string) {
  const mermaids: string[] = [];
  const diffs: string[] = [];
  let source = normalizeSummaryMarkdown(unwrapMarkdownFence(input || ""));
  source = source.replace(/```mermaid\n([\s\S]*?)```/g, (_m, code) => {
    const token = `MERMAIDTOKEN${mermaids.length}`;
    mermaids.push(`<pre class="mermaid language-mermaid">${escapeHtml(code.trim())}</pre>`);
    return token;
  });
  source = await replaceAsync(source, /```diff\n([\s\S]*?)```/g, async (_m, code) => {
    const token = `DIFFTOKEN${diffs.length}`;
    diffs.push(await renderDiffSnippet(code.trim()));
    return token;
  });
  const html = marked.parse(source, { async: false, breaks: true, gfm: true }) as string;
  return html
    .replace(/MERMAIDTOKEN(\d+)/g, (_m, i) => mermaids[Number(i)] || "")
    .replace(/DIFFTOKEN(\d+)/g, (_m, i) => diffs[Number(i)] || "");
}

async function renderDiffSnippet(diff: string) {
  const rendered = await renderDiff(diff);
  return `<div class="summary-diff">${rendered}</div>`;
}

async function replaceAsync(input: string, pattern: RegExp, replace: (...args: any[]) => Promise<string>) {
  const matches = [...input.matchAll(pattern)];
  const replacements = await Promise.all(matches.map((match) => replace(...match)));
  let index = 0;
  return input.replace(pattern, () => replacements[index++] || "");
}

function unwrapMarkdownFence(input: string) {
  const lines = input.trim().split("\n");
  if (/^```(?:markdown|md)?\s*$/i.test(lines[0] || "") && /^```\s*$/.test(lines.at(-1) || "")) {
    return lines.slice(1, -1).join("\n");
  }
  return input;
}

function normalizeSummaryMarkdown(input: string) {
  const lines = input.replace(/^\n+|\n+$/g, "").split("\n");
  let inFence = false;
  const indents = lines.flatMap((line) => {
    if (/^\s*```/.test(line)) {
      inFence = !inFence;
      return [];
    }
    if (inFence || !line.trim()) return [];
    return [line.match(/^\s*/)?.[0].length ?? 0];
  });
  const positiveIndents = indents.filter((n) => n > 0);
  const commonIndent = positiveIndents.length === indents.length && positiveIndents.length > 0 ? Math.min(...positiveIndents) : 0;
  return lines.map((line) => line.slice(Math.min(commonIndent, line.match(/^\s*/)?.[0].length ?? 0))).join("\n");
}

function defaultSummary() {
  return "# Generating summary…\n\n> Reading the diff and turning it into a short outside-in review story.";
}

function summaryPrompt(target: string, stats: DiffStats) {
  return `You are writing the summary shown above an HTML code-review diff (${target || "uncommitted"}).

The git diff is supplied on stdin. Use it as the source of truth.

Return raw markdown only. Do not wrap the response in a fenced code block.

Required format:
# <short title for the whole change>

> <one-sentence TL;DR explaining the net effect>

<stat line: ${stats.files} files, +${stats.additions}, -${stats.deletions}>

<summary>

Write the summary as a compact outside-in story: start with the user/API/behavioral outcome, then move inward through the main implementation changes, then tests/verification. Generally cover all changed areas/files, but only add context where the diff alone needs help. Include file-path bullets where useful so the summary carries the actual changes, not just commentary.

When including code, include complete unified diff snippets in \`\`\`diff fences copied from the git diff (with headers/hunks when possible). The UI renders these with the same diff viewer as the full diff, not as markdown code blocks. Do not use plain code fences for changed code.

Use Mermaid diagrams only for structural/control-flow changes that genuinely benefit from a diagram.

Avoid ELI5, generic praise, exhaustive line-by-line narration, and repeating obvious syntax.`;
}

function setSummaryStatus(ctx: ExtensionContext, line: string, detail?: string) {
  ctx.ui.setWidget(SUMMARY_STATUS_WIDGET_ID, detail ? [line, detail] : [line]);
}

function generateSummaryInBackground(ctx: ExtensionContext, target: string) {
  if (!state?.diff.trim()) {
    setSummaryStatus(ctx, "Review summary: no diff to summarize");
    return;
  }

  const runId = ++summaryRunId;
  const diff = state.diff.length > 90000 ? state.diff.slice(0, 90000) + "\n...<truncated>" : state.diff;
  setSummaryStatus(ctx, "Review summary: generating…", `${state.stats.files} files, +${state.stats.additions}, -${state.stats.deletions}`);

  const child = spawn("pi", ["--no-session", "--no-context-files", "-p", summaryPrompt(target, state.stats)], {
    cwd: ctx.cwd,
    stdio: ["pipe", "pipe", "pipe"],
    env: process.env,
  });

  let stdout = "";
  let stderr = "";
  child.stdout.on("data", (chunk) => stdout += chunk);
  child.stderr.on("data", (chunk) => stderr += chunk);
  child.on("error", (error) => {
    if (runId === summaryRunId) setSummaryStatus(ctx, "Review summary: failed", error.message);
  });
  child.on("close", async (code) => {
    if (!state || runId !== summaryRunId) return;
    const summary = stdout.trim();
    const ok = code === 0 && summary;
    state.summary = ok
      ? summary
      : `Summary failed.\n\n\`\`\`\n${(stderr || `pi exited ${code}`).trim()}\n\`\`\``;
    setSummaryStatus(ctx, ok ? "Review summary: ready" : "Review summary: failed", ok ? `${state.stats.files} files summarized` : (stderr || `pi exited ${code}`).trim().slice(0, 120));
    await refresh(ctx, true);
    broadcast();
  });
  child.stdin.end(`<git-diff>\n${diff}\n</git-diff>`);
}

function textResult(text: string) { return { content: [{ type: "text" as const, text }] }; }
function sha(s: string) { return createHash("sha1").update(s).digest("hex"); }
function escapeHtml(s: string) { return String(s).replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]!)); }
function escapeAttr(s: string) { return escapeHtml(s).replace(/`/g, "&#96;"); }
