#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
LAUNCH="$SKILL_DIR/scripts/launch-thread"
FINISH="$SKILL_DIR/scripts/finish-thread"
SANDBOX=$(mktemp -d "${TMPDIR:-/tmp}/new-thread-test.XXXXXX")
trap 'rm -rf "$SANDBOX"' EXIT

fail() {
  printf 'FAIL %s\n' "$*" >&2
  exit 1
}

assert_eq() {
  [[ "$1" == "$2" ]] || fail "expected '$2', got '$1'"
}

assert_log_lacks() {
  ! grep -Fq "$1" "$MOCK_LOG" || fail "unexpected call containing '$1'"
}

make_fixture() {
  local id=$1
  export MOCK_ROOT="$SANDBOX/$id"
  export MOCK_MAIN="$MOCK_ROOT/main"
  export MOCK_WORKTREE="$MOCK_MAIN/.wt/worktrees/$id"
  export MOCK_LOG="$MOCK_ROOT/calls.log"
  export MOCK_DISPOSITION=workspace_created
  export MOCK_WORKSPACE_ROOT="$MOCK_WORKTREE"
  export MOCK_FAIL_READ=0
  mkdir -p "$MOCK_MAIN/.git" "$MOCK_ROOT/bin"
  : > "$MOCK_LOG"

  cat > "$MOCK_ROOT/bin/git" <<'MOCK'
#!/bin/sh
case "$*" in
  'rev-parse --path-format=absolute --git-common-dir') printf '%s\n' "$MOCK_MAIN/.git" ;;
  *) echo "unexpected git call: $*" >&2; exit 2 ;;
esac
MOCK

  cat > "$MOCK_ROOT/bin/wt" <<'MOCK'
#!/bin/sh
printf 'wt %s\n' "$*" >> "$MOCK_LOG"
case "$1" in
  create)
    mkdir -p "$MOCK_WORKTREE"
    printf 'created\n%s\n' "$MOCK_WORKTREE"
    ;;
  rm)
    rm -rf "$MOCK_WORKTREE"
    ;;
  done)
    rm -rf "$MOCK_WORKTREE"
    ;;
  *) exit 2 ;;
esac
MOCK

  cat > "$MOCK_ROOT/bin/fut" <<'MOCK'
#!/bin/sh
printf 'fut %s\n' "$*" >> "$MOCK_LOG"
case "$*" in
  'agent prompt --help') printf '%s\n' '      --stdin' ;;
  '--json open '*)
    jq -n --arg disposition "$MOCK_DISPOSITION" '{result: {disposition: $disposition, selected: {workspace_id: "ws-1", pane_id: "pane-1", terminal_id: "term-1"}}}'
    ;;
  '--json agent get term-1')
    jq -n '{result: {agent: {available: true}, activity: {state: "completed"}}}'
    ;;
  '--json get ws-1')
    jq -n --arg root "$MOCK_WORKSPACE_ROOT" '{result: {target: {workspace: {root: $root}}}}'
    ;;
  '--json agent prompt term-1 --stdin')
    cat >/dev/null
    jq -n '{result: {submitted: true}}'
    ;;
  '--json agent read term-1 --source recent-unwrapped --lines 2000')
    if [[ "$MOCK_FAIL_READ" == 1 ]]; then
      echo '{"error":"terminal_exited"}' >&2
      exit 1
    fi
    jq -n '{result: {activity: {state: "completed"}, output: {text: "final words"}}}'
    ;;
  '--json workspace close ws-1')
    jq -n '{result: {closed: true}}'
    ;;
  *) echo "unexpected fut call: $*" >&2; exit 2 ;;
esac
MOCK

  cat > "$MOCK_ROOT/bin/pi" <<'MOCK'
#!/bin/sh
exit 0
MOCK
  chmod +x "$MOCK_ROOT/bin/git" "$MOCK_ROOT/bin/wt" "$MOCK_ROOT/bin/fut" "$MOCK_ROOT/bin/pi"
  export PATH="$MOCK_ROOT/bin:$ORIGINAL_PATH"
}

launch_fixture() {
  local id=$1
  printf 'Implement the task literally: $HOME `date`.\n' |
    (cd "$MOCK_MAIN" && "$LAUNCH" "$id" --workspace-name "Test $id")
}

ORIGINAL_PATH=$PATH

for disposition in workspace_created session_created; do
  make_fixture "$disposition"
  export MOCK_DISPOSITION=$disposition
  result=$(launch_fixture "$disposition")
  manifest=$(printf '%s' "$result" | jq -r '.manifest_path')
  assert_eq "$(jq -r '.disposition' "$manifest")" "$disposition"
  assert_eq "$(jq -r '.prompt.submitted' "$manifest")" true
  assert_eq "$(jq -r '.lifecycle.state' "$manifest")" prompted
  assert_eq "$manifest" "$MOCK_MAIN/.git/new-thread/ws-1.json"
done
printf 'ok   workspace_created and session_created launches\n'

for disposition in existing workspace_reused; do
  make_fixture "$disposition"
  export MOCK_DISPOSITION=$disposition
  if launch_fixture "$disposition" >"$MOCK_ROOT/stdout" 2>"$MOCK_ROOT/stderr"; then
    fail "$disposition disposition was accepted"
  fi
  [[ -d "$MOCK_WORKTREE" ]] || fail "rejected $disposition disposition removed the worktree"
  assert_log_lacks 'agent prompt term-1'
  [[ ! -e "$MOCK_MAIN/.git/new-thread/ws-1.json" ]] || fail "$disposition workspace was recorded as owned"
done
printf 'ok   existing and reuse refusals retain the worktree\n'

make_fixture root-mismatch
mkdir -p "$MOCK_ROOT/wrong-root"
export MOCK_WORKSPACE_ROOT="$MOCK_ROOT/wrong-root"
if launch_fixture root-mismatch >"$MOCK_ROOT/stdout" 2>"$MOCK_ROOT/stderr"; then
  fail "mismatched workspace root was accepted"
fi
manifest="$MOCK_MAIN/.git/new-thread/ws-1.json"
assert_eq "$(jq -r '.lifecycle.state' "$manifest")" launch_failed
[[ -d "$MOCK_WORKTREE" ]] || fail "root mismatch removed the worktree"
assert_log_lacks 'agent prompt term-1'
printf 'ok   exact-root failure is durable and non-destructive\n'

make_fixture persistence
manifest=$(launch_fixture persistence | jq -r '.manifest_path')
: > "$MOCK_LOG"
(cd "$SANDBOX" && "$FINISH" "$manifest" --done) > "$MOCK_ROOT/finish.json"
[[ -f "$manifest" ]] || fail "final report was removed with the worktree"
[[ ! -d "$MOCK_WORKTREE" ]] || fail "worktree was not removed"
assert_eq "$(jq -r '.final.output.output.text' "$manifest")" 'final words'
assert_eq "$(jq -r '.final.agent.activity.state' "$manifest")" completed
assert_eq "$(jq -r '.lifecycle.state' "$manifest")" completed
assert_eq "$(jq -r '.teardown.mode' "$manifest")" 'done'
read_line=$(grep -nF 'fut --json agent read term-1' "$MOCK_LOG" | cut -d: -f1)
close_line=$(grep -nF 'fut --json workspace close ws-1' "$MOCK_LOG" | cut -d: -f1)
remove_line=$(grep -nF 'wt done' "$MOCK_LOG" | cut -d: -f1)
((read_line < close_line && close_line < remove_line)) || fail "capture, close, and removal ran out of order"
printf 'ok   final output persists before workspace close and worktree removal\n'

make_fixture capture-failure
manifest=$(launch_fixture capture-failure | jq -r '.manifest_path')
: > "$MOCK_LOG"
export MOCK_FAIL_READ=1
if (cd "$SANDBOX" && "$FINISH" "$manifest" --abandon) >"$MOCK_ROOT/stdout" 2>"$MOCK_ROOT/stderr"; then
  fail "completion continued after output capture failed"
fi
assert_eq "$(jq -r '.lifecycle.state' "$manifest")" capture_failed
[[ -d "$MOCK_WORKTREE" ]] || fail "capture failure removed the worktree"
assert_log_lacks 'workspace close ws-1'
assert_log_lacks 'wt rm capture-failure'
printf 'ok   capture failure preserves workspace and worktree\n'

make_fixture ownership
manifest=$(launch_fixture ownership | jq -r '.manifest_path')
: > "$MOCK_LOG"
if FUT_WORKSPACE_ID=ws-1 "$FINISH" "$manifest" --abandon >"$MOCK_ROOT/stdout" 2>"$MOCK_ROOT/stderr"; then
  fail "owned workspace was allowed to retire itself"
fi
[[ -d "$MOCK_WORKTREE" ]] || fail "ownership refusal removed the worktree"
assert_log_lacks 'agent get term-1'
printf 'ok   child completion ownership is refused safely\n'
