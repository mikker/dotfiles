(() => {
  const buttonId = "sprinkles-helpscout-copy-md";
  const style = document.createElement("style");
  style.id = `${buttonId}-style`;
  style.textContent = `
    #${buttonId} {
      position: fixed;
      bottom: 24px;
      right: 24px;
      z-index: 10000;
      isolation: isolate;
      overflow: hidden;
      padding: 20px 32px;
      border: 2px solid #ffe1a0;
      border-radius: 20px 6px 20px 6px;
      background: linear-gradient(125deg, #741044, #c92258 45%, #ed7040);
      color: #fff6df;
      font: 750 20px/1.3 system-ui, sans-serif;
      letter-spacing: .03em;
      text-shadow: 0 2px 4px #650d42;
      box-shadow: 0 0 0 4px #b81e5733, 0 8px 0 #741044,
        0 16px 32px #74104444, inset 0 1px 0 #ffffff66;
      cursor: pointer;
      transition: transform .2s, box-shadow .2s, filter .2s;
    }
    #${buttonId}::before {
      content: "";
      position: absolute;
      inset: -100%;
      z-index: -1;
      background: linear-gradient(110deg, transparent 42%, #fff6df55 50%, transparent 58%);
      animation: sprinkles-flamenco-shimmer 4s ease-in-out infinite;
      pointer-events: none;
    }
    #${buttonId}::after {
      content: "✦";
      display: inline-block;
      margin-left: 14px;
      color: #ffe1a0;
      transition: transform .4s;
    }
    #${buttonId}:hover:not(:disabled) {
      transform: translateY(-4px) rotate(-2deg);
      filter: saturate(1.2);
      box-shadow: 0 0 0 6px #b81e5722, 0 12px 0 #741044,
        0 22px 40px #74104455, inset 0 1px 0 #ffffff66;
    }
    #${buttonId}:hover::after { transform: rotate(180deg) scale(1.3); }
    #${buttonId}:active:not(:disabled) {
      transform: translateY(5px);
      box-shadow: 0 0 0 4px #b81e5733, 0 3px 0 #741044;
    }
    #${buttonId}:focus-visible { outline: 3px solid #741044; outline-offset: 7px; }
    #${buttonId}:disabled { cursor: default; }
    #${buttonId}[hidden] { display: none; }
    @keyframes sprinkles-flamenco-shimmer {
      0%, 25% { transform: translateX(-60%); }
      65%, 100% { transform: translateX(60%); }
    }
    @media (prefers-reduced-motion: reduce) {
      #${buttonId}, #${buttonId}::after { transition: none; }
      #${buttonId}::before { animation: none; display: none; }
      #${buttonId}:hover:not(:disabled) { transform: none; }
    }
  `;
  document.getElementById(style.id)?.remove();
  document.documentElement.appendChild(style);
  if (document.getElementById(buttonId)) return;

  const button = document.createElement("button");
  button.id = buttonId;
  button.type = "button";
  button.textContent = "💃 Copy as MD";
  button.title = "Copy this conversation as Markdown (including internal notes)";

  const text = (element) => element?.textContent.trim() || "";
  const escape = (value) => value.replace(/([\\`*_\[\]<>#])/g, "\\$1");
  const destination = (value) => new URL(value, location.href).href.replace(/[()]/g, encodeURIComponent);

  // Convert message HTML locally; no CDN, API token, or customer data leaves the page.
  function markdown(node) {
    if (node.nodeType === Node.TEXT_NODE) return escape(node.textContent.replace(/\s+/g, " "));
    if (node.nodeType !== Node.ELEMENT_NODE) return "";
    const children = () => Array.from(node.childNodes, markdown).join("");
    switch (node.tagName) {
      case "SCRIPT":
      case "STYLE":
      case "BUTTON":
        return "";
      case "BR": return "\n";
      case "HR": return "\n\n---\n\n";
      case "B":
      case "STRONG": return `**${children().trim()}**`;
      case "I":
      case "EM": return `*${children().trim()}*`;
      case "DEL":
      case "S": return `~~${children().trim()}~~`;
      case "A": return node.hasAttribute("href") ? `[${children().trim() || escape(node.href)}](${destination(node.getAttribute("href"))})` : children();
      case "IMG": return node.hasAttribute("src") ? `![${escape(node.alt || "image")}](${destination(node.getAttribute("src"))})` : "";
      case "PRE": {
        const content = node.textContent.replace(/\n$/, "");
        const fence = "`".repeat(Math.max(3, ...Array.from(content.matchAll(/`+/g), (match) => match[0].length + 1)));
        return `\n\n${fence}\n${content}\n${fence}\n\n`;
      }
      case "CODE": {
        const content = node.textContent;
        const fence = "`".repeat(Math.max(1, ...Array.from(content.matchAll(/`+/g), (match) => match[0].length + 1)));
        return `${fence} ${content} ${fence}`;
      }
      case "BLOCKQUOTE": return `\n\n${children().trim().split("\n").map((line) => `> ${line}`).join("\n")}\n\n`;
      case "UL":
      case "OL":
        return "\n\n" + Array.from(node.children, (item, index) => {
          const marker = node.tagName === "OL" ? `${Number(node.getAttribute("start") || 1) + index}. ` : "- ";
          return marker + markdown(item).trim().replace(/\n/g, "\n" + " ".repeat(marker.length));
        }).join("\n") + "\n\n";
      case "P":
      case "DIV": return `\n\n${children()}\n\n`;
      case "H1":
      case "H2":
      case "H3":
      case "H4":
      case "H5":
      case "H6": return `\n\n${"#".repeat(Number(node.tagName[1]))} ${children()}\n\n`;
      case "TR": return `\n${children()}\n`;
      case "TD":
      case "TH": return `${children()} · `;
      default: return children();
    }
  }

  function conversationMarkdown() {
    const subject = document.querySelector('[aria-label="Conversation Subject"]');
    const threads = Array.from(document.querySelectorAll('[aria-label="Thread Items"] .thread-item'));
    if (!subject || !threads.length) throw new Error("No conversation found");
    const url = new URL(location.href);
    url.search = "";
    url.hash = "";
    const messages = threads.map((thread) => {
      const toggle = thread.querySelector(".toggle-collapse-state");
      // Never silently copy a collapsed preview as if it were the full message.
      if (toggle && !toggle.classList.contains("is-expanded")) {
        throw new Error("Expand all messages first");
      }
      // The header is followed by the body section; its first child holds the
      // message, before delivery receipts/infoboxes. Table-layout classes vary
      // between messages and aren't a reliable way to identify their content.
      const body = toggle?.parentElement.nextElementSibling?.firstElementChild;
      if (!body) throw new Error("Could not find message content");
      const author = text(thread.querySelector("span[data-nocollapse]")) || "Unknown author";
      const timestamp = thread.querySelector('[data-testid="timestamp"] a');
      const date = timestamp?.getAttribute("data-printformattedtime") || text(timestamp);
      const kind = thread.getAttribute("aria-label") || "Message";
      const recipients = ["From", "To", "Cc"].flatMap((field) => {
        const value = text(thread.querySelector(`[data-cy="OtherRecipients.${field}"]`));
        return value ? [`**${field}:** ${escape(value)}`] : [];
      });
      return [
        `## ${escape(author)} — ${escape(kind)}`,
        date && escape(date),
        recipients.join("\n"),
        markdown(body).replace(/\n[ \t]+/g, "\n").replace(/\n{3,}/g, "\n\n").trim(),
      ].filter(Boolean).join("\n\n");
    });
    return `# ${escape(text(subject))}\n\n[Help Scout conversation](${url.href})\n\n${messages.join("\n\n---\n\n")}\n`;
  }

  button.addEventListener("click", async () => {
    button.disabled = true;
    try {
      await navigator.clipboard.writeText(conversationMarkdown());
      button.textContent = "💃 ¡Olé! Copied!";
    } catch (error) {
      button.textContent = error.message === "Expand all messages first" ? error.message : "Copy failed — try again";
      console.error("Help Scout Markdown copy:", error);
    } finally {
      setTimeout(() => {
        button.textContent = "💃 Copy as MD";
        button.disabled = false;
      }, 2500);
    }
  });

  function mount() {
    const visible = /\/conversation\/\d+/.test(location.pathname) && document.querySelector('[aria-label="Thread Items"]');
    button.hidden = !visible;
    if (document.body && !button.isConnected) document.body.appendChild(button);
  }

  // Help Scout replaces the conversation without a full page load.
  new MutationObserver(mount).observe(document.documentElement, { childList: true, subtree: true });
  mount();
})();
