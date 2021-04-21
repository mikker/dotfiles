function lookup() {
  return document.body.querySelector('style[data-sprinkles-injected]')
}

setTimeout(() => {
  const style = lookup()

  document.addEventListener('turbo:load', () => {
    if (lookup()) return;
    document.body.appendChild(style)
  })
}, 0)
