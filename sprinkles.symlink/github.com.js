// ============================================
// ctrl+r selects and clicks "Rebase and Merge"
// ============================================
document.addEventListener("keydown", event => {
  if (event.ctrlKey && event.keyCode === 82) rebase();
});

async function rebase() {
  const button = q('[data-details-container=".js-merge-pr"]');

  if (button.innerText !== "Rebase and merge") {
    q('[aria-label="Select merge method"]').click();
    await sleep(250);

    q('.js-merge-method-menu button[value="rebase"]').click()
    await sleep(250);
  }

  button.click();
  await sleep(250);

  q(".btn-group-rebase .js-merge-commit-button").click();
}

function sleep(delay) {
  return new Promise(resolve => {
    setTimeout(resolve, delay);
  });
}

function q(selector) {
  return document.querySelector(selector);
}
