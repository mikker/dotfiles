setupPip();

function setupPip() {
  document.addEventListener("keyup", event => {
    if (event.keyCode === 80 && event.ctrlKey && event.altKey) {
      document
        .querySelector("video")
        .webkitSetPresentationMode("picture-in-picture");
    }
  });
}
