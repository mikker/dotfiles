console.log("Loading github.js")

// ============================================
// ctrl+r selects and clicks "Rebase and Merge"
// ============================================
document.addEventListener("keydown", (event) => {
  if (event.ctrlKey && event.key === "r") rebase();
});

async function rebase() {
  const button = q('[aria-describedby*="loading-announcement"]');
  console.log(button.innerText);

  if (button.innerText !== "Squash and merge") {
    //   q('[aria-label="Select merge method"]').click();
    //   await sleep(250);
    //
    //   q('.js-merge-method-menu button[value="squash"]').click();
    //   await sleep(250);
  }

  button.click();
  await sleep(100);

  q('[aria-describedby*="loading-announcement"]').click();
}

function sleep(delay) {
  return new Promise((resolve) => {
    setTimeout(resolve, delay);
  });
}

function q(selector) {
  return document.querySelector(selector);
}
