async function rebase() {
  const button = document.querySelector(
    '[data-details-container=".js-merge-pr"]'
  );

  if (button.innerText !== "Rebase and merge") {
    document.querySelector('[aria-label="Select merge method"]').click();
    await sleep(250);
    document
      .querySelector('.js-merge-method-menu button[value="rebase"]')
      .click();
    await sleep(250);
  }

  button.click();
  await sleep(250);

  document.querySelector(".btn-group-rebase .js-merge-commit-button").click()
}

document.addEventListener("keydown", event => {
  // ctrl+r
  if (event.ctrlKey && event.keyCode === 82) rebase();
});

function sleep(delay) {
  return new Promise(resolve => {
    setTimeout(resolve, delay);
  });
}
