#!/usr/bin/env bash

if [[ -z "${DOTFILES_ROOT:-}" ]]; then
  DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

path_exists() {
  [[ -e "$1" || -L "$1" ]]
}

same_link() {
  local dest="$1"
  local source="$2"

  [[ -L "$dest" ]] || return 1
  [[ "$(command readlink "$dest")" == "$source" ]]
}

remove_path() {
  local path="$1"

  if [[ -L "$path" || -f "$path" ]]; then
    command rm -f "$path"
    return
  fi

  command rm -rf "$path"
}

resolve_source() {
  local source="$1"

  if [[ "$source" = /* ]]; then
    printf '%s\n' "$source"
    return
  fi

  printf '%s\n' "$DOTFILES_ROOT/$source"
}

link_path() {
  local source
  source="$(resolve_source "$1")"

  local dest="$2"
  command mkdir -p "$(dirname "$dest")"

  if same_link "$dest" "$source"; then
    printf 'Already linked %s\n' "$dest"
    return
  fi

  if path_exists "$dest"; then
    remove_path "$dest"
  fi

  command ln -s "$source" "$dest"
  printf 'Linked %s -> %s\n' "$dest" "$source"
}

copy_path() {
  local source
  source="$(resolve_source "$1")"

  local dest="$2"
  command mkdir -p "$(dirname "$dest")"

  if path_exists "$dest" && [[ ! -f "$dest" ]]; then
    remove_path "$dest"
  fi

  if [[ -f "$dest" ]] && command cmp -s "$source" "$dest"; then
    printf 'Unchanged %s\n' "$dest"
    return
  fi

  command cp -f "$source" "$dest"
  printf 'Copied %s -> %s\n' "$source" "$dest"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}
