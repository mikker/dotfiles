function main() {
  console.log("tick");

  // Find the header signifying current timeline mode
  const title = document.querySelector(
    '[data-testid="primaryColumn"] h2[role="heading"]'
  );

  // If it isn't loaded yet, try again in 0.5 secs
  if (!title) {
    setTimeout(main, 500);
    return;
  }

  // If not matching Home, stop looking
  if (title.innerText !== "Home") return;

  // If Home, continue
  console.log("Match!");

  // Click ✨
  document.querySelector('[aria-label="Top Tweets on"]').click();

  // Wait 0.5 secs then click "Latest tweets"
  setTimeout(() => {
    console.log("Click!");
    document.querySelector('div[role="menuitem"]').click();
  }, 500);
}

main();
