-- Omarchy Shell UI remains proportional even when the system monospace alias
-- is changed for terminals and code-oriented applications.
hl.env("OMARCHY_MENU_FONT", "Inter")

-- GNOME Keyring-backed SSH agent. UWSM also exports this on future logins;
-- declaring it here makes newly launched apps use it in the current session.
local xdg_runtime_dir = os.getenv("XDG_RUNTIME_DIR")
if xdg_runtime_dir then
  hl.env("SSH_AUTH_SOCK", xdg_runtime_dir .. "/gcr/ssh")
end
