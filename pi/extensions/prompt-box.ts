import {
  CustomEditor,
  SettingsManager,
  type ExtensionAPI,
  type KeybindingsManager,
} from "@earendil-works/pi-coding-agent";
import {
  truncateToWidth,
  visibleWidth,
  type EditorTheme,
  type TUI,
} from "@earendil-works/pi-tui";

const SGR_PATTERN = /\x1b\[[0-9;]*m/g;
const DIM = "\x1b[2m";
const NOT_DIM = "\x1b[22m";

function fitLine(line: string, width: number): string {
  const fitted = truncateToWidth(line, width, "");
  return fitted + " ".repeat(Math.max(0, width - visibleWidth(fitted)));
}

function isEditorRule(line: string): boolean {
  const plain = line.replace(SGR_PATTERN, "");
  return plain.startsWith("─") && /^[─↑↓0-9 more.]+$/.test(plain);
}

class PromptBoxEditor extends CustomEditor {
  constructor(
    tui: TUI,
    theme: EditorTheme,
    keybindings: KeybindingsManager,
    autocompleteMaxVisible: number,
  ) {
    super(tui, theme, keybindings, { autocompleteMaxVisible });
  }

  override render(width: number): string[] {
    if (width < 8) return super.render(width);

    const innerWidth = width - 4;
    const rendered = super.render(innerWidth);
    let closingRuleIndex = -1;

    for (let index = rendered.length - 1; index > 0; index -= 1) {
      if (isEditorRule(rendered[index]!)) {
        closingRuleIndex = index;
        break;
      }
    }

    if (closingRuleIndex < 2) return super.render(width);

    const dim = (text: string) => `${DIM}${text}${NOT_DIM}`;
    const border = (text: string) => dim(this.borderColor(text));
    const framedRule = (left: string, rule: string, right: string) =>
      `${border(`${left}─`)}${dim(fitLine(rule, innerWidth))}${border(`─${right}`)}`;
    const framedLine = (line: string) =>
      `${border("│")} ${fitLine(line, innerWidth)} ${border("│")}`;

    const topRule = rendered[0]!;
    const bottomRule = rendered[closingRuleIndex]!;
    const body = rendered.slice(1, closingRuleIndex).map(framedLine);
    const autocomplete = rendered.slice(closingRuleIndex + 1).map(framedLine);
    const lines = [framedRule("╭", topRule, "╮"), ...body];

    if (autocomplete.length > 0) {
      lines.push(
        framedRule("├", bottomRule, "┤"),
        ...autocomplete,
        border(`╰${"─".repeat(width - 2)}╯`),
      );
    } else {
      lines.push(framedRule("╰", bottomRule, "╯"));
    }

    return lines;
  }
}

export default function promptBox(pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui" || ctx.ui.getEditorComponent()) return;

    const autocompleteMaxVisible = SettingsManager.create(ctx.cwd, undefined, {
      projectTrusted: ctx.isProjectTrusted(),
    }).getAutocompleteMaxVisible();

    ctx.ui.setEditorComponent(
      (tui, theme, keybindings) =>
        new PromptBoxEditor(tui, theme, keybindings, autocompleteMaxVisible),
    );
  });
}
