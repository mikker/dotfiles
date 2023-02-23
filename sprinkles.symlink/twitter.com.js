window.addEventListener("load", function () {
  const hours = new Date().getHours();
  if (hours < 9 || hours >= 14) return;
  document.querySelector("body").classList.add("blurred");
});

document.addEventListener("keydown", (event) => {
  if (!onlyCtrl(event)) return;

  if (event.key === "a") {
    const url = document.querySelector(
      'video[type="application/x-mpegURL"]'
    ).src;
    window.open(url);
  }
});

function onlyCtrl(event) {
  return event.ctrlKey && !event.shiftKey && !event.metaKey;
}

main();
