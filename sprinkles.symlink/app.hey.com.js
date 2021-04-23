let style;

function lookup() {
  return document.body.querySelector("style[data-sprinkles-injected]");
}

function ensureStyles() {
  if (lookup()) return;

  console.log("appending styles");
  document.body.appendChild(style);
}

function boot() {
  console.log("boot");
  ensureStyles();
  bootReadMarks();
}

function bootReadMarks() {
  if (!document.querySelector(".inboxes--feed")) return;

  const marks = new Marks();

  const items = document.querySelectorAll(".inboxes--feed article.posting");
  for (const item of items) {
    insertCheck(item, marks)
  }

  const obs = new MutationObserver((mutationList) => {
    for (const mutation of mutationList) {
      for (const item of mutation.addedNodes) {
        insertCheck(item, marks)
      }
    }
  })

  obs.observe(document.getElementById('postings'), { childList: true })
}

function insertCheck(item, marks) {
  if (item.nodeName !== 'ARTICLE') return;
  if (item.querySelector("[data-sprinkles-check]")) return;

  const check = document.createElement("input");
  check.type = "checkbox";
  check.dataset.sprinklesCheck = 1;

  const id = item.dataset.identifier;
  const checked = marks.has(id);
  check.dataset.identifier = id;
  check.checked = checked;
  check.style.transform = "scale(1.5)";
  check.style.marginRight = '10px'

  item.querySelector(".topic__header").prepend(check);

  check.addEventListener("change", (event) => {
    const id = event.target.dataset.identifier;
    event.target.checked ? marks.add(id) : marks.delete(id);
    toggleDim(item, event.target.checked);
  });

  toggleDim(item, checked);
}

function toggleDim(item, on = true) {
  item.style.opacity = on ? "0.1" : 1;
}

class Marks {
  constructor(key = "marks") {
    this.key = key;
    this.load();
    this.save();
  }

  load() {
    let marks;
    try {
      marks = JSON.parse(window.localStorage.getItem("marks"));
    } catch (err) {}

    this.data = new Set(marks);

    return this;
  }

  save() {
    return window.localStorage.setItem("marks", JSON.stringify([...this.data]));
  }

  add(id) {
    this.data.add(id);
    return this.save();
  }

  delete(id) {
    this.data.delete(id);
    return this.save();
  }

  has(id) {
    return this.data.has(id);
  }
}

setTimeout(() => {
  style = lookup();
  boot();
}, 0);

document.addEventListener("turbo:load", boot);
