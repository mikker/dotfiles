// Lets me scroll by half a page instead of a whole page (space bar)
// Bound to ctrl+d and ctrl+u -- like in vim
setupScrollByCtrlDAndU();

// Speed up any <video> by shift-clicking on it
// Every click bumps the speed by .25 until it resets
//   eg. 1 -> 1.25 -> 1.5 -> 1
setupVideoSpeedThing();

// Remove weird fonts and font-widths from unreadably sites with ctrl-alt-s
setupSystemFontResetter();

// Focus the first search input with "/"
setupSearchFieldFinder();

function setupVideoSpeedThing() {
  document.addEventListener("mouseup", (event) => {
    if (!event.shiftKey || event.ctrlKey || event.metaKey) return;

    const video = findCorrespondingVideoElement(event);
    if (!video) return;

    event.preventDefault();

    switch (video.playbackRate) {
      case 1:
        video.playbackRate = 1.25;
        break;
      case 1.25:
        video.playbackRate = 1.5;
        break;
      default:
        video.playbackRate = 1;
        break;
    }

    console.log(
      `%cplayback rate set to ${video.playbackRate}`,
      "color: purple"
    );
  });
}

function setupScrollByCtrlDAndU() {
  document.addEventListener("keydown", (event) => {
    if (!onlyCtrl(event)) return;

    if (event.code === "KeyD") return scroll("down");
    if (event.code === "KeyU") return scroll("up");
  });

  function scroll(direction) {
    const distance = (window.innerHeight / 10) * 5;

    let dest;
    if (direction === "up") {
      dest = window.scrollY - distance;
    } else {
      dest = window.scrollY + distance;
    }

    let start = window.scrollY;
    let change = dest - start;
    let currentTime = 0;
    const increment = 20;
    const duration = 150;

    function tick() {
      currentTime += increment;
      const pos = currentTime / duration;

      document.scrollingElement.scrollTo(
        0,
        start + change * EasingFunctions.easeOutQuad(pos)
      );

      if (currentTime < duration) {
        requestAnimationFrame(tick);
      }
    }

    tick();
  }

  function onlyCtrl(event) {
    return event.ctrlKey && !event.shiftKey && !event.metaKey;
  }
}

function setupSystemFontResetter() {
  let styleElm = null;

  document.addEventListener("keyup", (event) => {
    if (event.code === "KeyS" && event.ctrlKey && event.altKey) {
      if (styleElm) {
        styleElm.remove();
        styleElm = null;
        return;
      }

      const s = document.createElement("style");
      s.innerHTML = `
        @import url('https://rsms.me/inter/inter.css');
        html { font-family: 'Inter', sans-serif; }
        @supports (font-variation-settings: normal) {
          html { font-family: 'Inter var', sans-serif; }
        }

        * {
          font-family: "Inter var", system-ui, -apple-system, BlinkMacSystemFont,
            "Segoe UI", Roboto, Oxygen-Sans, Ubuntu, Cantarell,
            "Helvetica Neue", sans-serif !important;
          font-weight: 400 !important;
          line-height: 1.5 !important;
        }
        h1, h2, h3, h4, h5, h6 {
          font-weight: 600 !important;
        }
        body {
          font-size: 16px;
          letter-spacing: 0;
        }
        p {
          max-width: 40em;
        }
        ul, ol {
          line-height: 1.5 !important;
        }
        pre, code, pre * {
          font-family: 'SF Mono', 'Menlo', monospace !important;
        }
      `;
      document.body.appendChild(s);

      styleElm = s;
    }
  });
}

const EasingFunctions = {
  // no easing, no acceleration
  linear: function (t) {
    return t;
  },
  // accelerating from zero velocity
  easeInQuad: function (t) {
    return t * t;
  },
  // decelerating to zero velocity
  easeOutQuad: function (t) {
    return t * (2 - t);
  },
  // acceleration until halfway, then deceleration
  easeInOutQuad: function (t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  },
  // accelerating from zero velocity
  easeInCubic: function (t) {
    return t * t * t;
  },
  // decelerating to zero velocity
  easeOutCubic: function (t) {
    return --t * t * t + 1;
  },
  // acceleration until halfway, then deceleration
  easeInOutCubic: function (t) {
    return t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1;
  },
  // accelerating from zero velocity
  easeInQuart: function (t) {
    return t * t * t * t;
  },
  // decelerating to zero velocity
  easeOutQuart: function (t) {
    return 1 - --t * t * t * t;
  },
  // acceleration until halfway, then deceleration
  easeInOutQuart: function (t) {
    return t < 0.5 ? 8 * t * t * t * t : 1 - 8 * --t * t * t * t;
  },
  // accelerating from zero velocity
  easeInQuint: function (t) {
    return t * t * t * t * t;
  },
  // decelerating to zero velocity
  easeOutQuint: function (t) {
    return 1 + --t * t * t * t * t;
  },
  // acceleration until halfway, then deceleration
  easeInOutQuint: function (t) {
    return t < 0.5 ? 16 * t * t * t * t * t : 1 + 16 * --t * t * t * t * t;
  },
};

function vimeoVideo(event) {
  return event.target.ownerDocument.querySelector(".video video");
}

function findCorrespondingVideoElement(event) {
  if (event.target.tagName === "VIDEO") return event.target;

  const vimeo = vimeoVideo(event);
  if (vimeo) return vimeo;

  return undefined;
}

// Adds / keyboard shortcut for focusing the search field if one exists
function setupSearchFieldFinder() {
  document.addEventListener("keyup", (event) => {
    if (event.code !== "Slash") return;
    if (document.querySelector("*:focus")) return; // another field has focus
    if (event.altKey || event.shiftKey || event.ctrlKey || event.metaKey)
      return; // no modifiers held

    let s;

    // First look for inputs with type=search
    s = document.querySelector('input[type="search"]');

    // Then try inputs with name=q …  common enough pattern
    if (!s) s = document.querySelector('input[type="text"][name="q"]');

    // If nothing, give up
    if (!s) return;

    console.info("Focusing search input");
    s.focus();
  });
}

function setupBookmarksbar() {
  let cleanslate;
  let bookmarksbar;

  const bookmarks = [
    {
      code: "Digit1",
      url: "https://github.com/notifications",
      title: "GH noties",
    },
    {
      code: "Digit2",
      url: "https://github.com/brnbw/10er",
      title: "brnbw/10er",
    },
  ];

  function addCleanSlate() {
    cleanslate = document.createElement("link");
    cleanslate.rel = "stylesheet";
    cleanslate.href =
      "https://raw.githubusercontent.com/premasagar/cleanslate/master/cleanslate.css";
    document.body.appendChild(cleanslate);
  }

  function buildBookmarksbar() {
    bookmarksbar = document.createElement("div");
    bookmarksbar.classList.add("cleanslate", "__bookmarksbar__");

    const styles = document.createElement("style");
    styles.innerHTML = `
      .__bookmarksbar__ {
        position: fixed !important;
        inset: 0 !important;
        background: hsl(0deg 0% 0% / 0.7) !important;
        backdrop-filter: blur(18px) !important;
        z-index: 99999 !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        gap: 1em !important;
        font-family: 'SF Mono', 'Menlo', monospace !important;
        font-size: 14px !important;
      }
      .__bookmarksbar__link {
        display: flex;
        align-items: center !important;
        gap: 0.75em !important;
        background: hsl(0deg 0% 100%) !important;
        border-radius: 999px !important;
        box-shadow: 0 0 0.5em hsl(0deg 0% 0% / 0.5) !important;
        padding: 0.5em 1em !important;
        color: #333 !important;
      }
      .__bookmarksbar__link:active, .__bookmarksbar__link:focus {
        background: hsl(0deg 0% 70%) !important;
        outline: 2px solid #19548d !important;
      }
      .__bookmarksbar__link__key {
        background: hsl(0deg 0% 90%) !important;
        box-shadow: inset -1px -1px 0px hsl(0deg 0% 0% / 0.1), inset 1px 1px 0px hsl(0deg 0% 100% / 0.8) !important;
        border: 1px solid hsl(0deg 0% 0% / 0.3) !important;
        color: #555 !important;
        border-radius: 3px !important;
        font-size: 12px !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        height: 24px !important;
        width: 24px !important;
      }
      .__bookmarksbar__link__title {
      }
    `;

    bookmarks.forEach((bookmark) => {
      const link = document.createElement("a");
      link.classList.add("__bookmarksbar__link");
      link.href = bookmark.url;

      const key = document.createElement("span");
      key.classList.add("__bookmarksbar__link__key");
      key.innerHTML = bookmark.code.replace(/^Digit/, "");
      const title = document.createElement("span");
      title.classList.add("__bookmarksbar__link__title");
      title.innerHTML = bookmark.title;

      link.appendChild(key);
      link.appendChild(title);

      bookmarksbar.appendChild(link);
      bookmark.element = link;
    });

    document.body.appendChild(styles);
    document.body.appendChild(bookmarksbar);
  }

  document.addEventListener("keydown", (e) => {
    if (e.ctrlKey && e.shiftKey && !e.metaKey && !e.altKey) {
      active = true;

      if (!cleanslate) addCleanSlate();
      if (!bookmarksbar) buildBookmarksbar();

      bookmarksbar.style.display = "flex";
    }
  });

  document.addEventListener("keyup", (e) => {
    if (!bookmarksbar) return;

    const bookmark = bookmarks.find((bookmark) => bookmark.code === e.code);
    if (bookmark) {
      bookmark.element.focus();
      bookmark.element.click();
    } else {
      bookmarksbar.remove();
      bookmarksbar = undefined;
    }
  });
}

setupBookmarksbar();
