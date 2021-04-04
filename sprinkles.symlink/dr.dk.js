setupPip();

function setupPip() {
  document.addEventListener("keyup", event => {
    // ctrl + alt + p
    if (event.keyCode === 80 && event.ctrlKey && event.altKey) {
      window.open(document.querySelector('video').currentSrc)
    }
  });
}
