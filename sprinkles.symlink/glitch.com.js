function ping() {
  var cm = document.querySelector(".CodeMirror");
  if (!cm) return;

  return;

  cm.classList.remove("cm-s-default");
  cm.classList.add("cm-s-oceanic-muted");
}

ping();
