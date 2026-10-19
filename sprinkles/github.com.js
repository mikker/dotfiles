console.log("Loading github.js");

// ============================================
// ctrl+r selects and clicks "Rebase and Merge"
// ============================================
document.addEventListener("keydown", (event) => {
  if (event.ctrlKey && event.key === "r") rebase();
});

function findButton(text) {
  for (let elm of Array.from(document.querySelectorAll("button"))) {
   if (elm.innerText === text) return elm
  }

  throw new Error(`Button "${text}" not found`)
}

async function rebase() {
  findButton("Squash and merge").click()
  await sleep(300)
  findButton("Confirm squash and merge").click()
}

function sleep(delay) {
  return new Promise((resolve) => {
    setTimeout(resolve, delay);
  });
}

