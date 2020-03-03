function rebase() {
  document.querySelector('[data-details-container=".js-merge-pr"]').click();

  setTimeout(() => {
    document.querySelector(".js-merge-pull-request").submit();
  }, 500);
}


document.addEventListener("keydown", event => {
  if (!(event.ctrlKey && !event.shiftKey && !event.metaKey)) return;
  if (event.keyCode !== 82) return;

  rebase()
});
