function main() {
  // Keyboard shortcuts
  document.addEventListener("keydown", handleKeyDown);
  document.addEventListener("keyup", handleKeyUp)

  // Video speed control
  document.addEventListener("mouseup", handleVideoSpeedClick);
}

function handleKeyDown(event) {
  // Ctrl+D and Ctrl+U for scrolling
  if (onlyCtrl(event)) {
    if (event.code === "KeyD") return scroll("down");
    if (event.code === "KeyU") return scroll("up");
  }

  // Ctrl+Alt+S for system font reset
  if (event.code === "KeyS" && event.ctrlKey && event.altKey) {
    toggleSystemFonts();
    return ok();
  }

  // Cmd+Ctrl+C to copy current URL
  if (event.code === "KeyC" && event.ctrlKey && event.metaKey) {
    event.preventDefault();
    copyCurrentURL();
    return ok();
  }
}

function handleKeyUp(event) {
  // Key up because otherwise it inputs "/" into field
  if (
    event.code === "Slash" &&
    !document.querySelector("*:focus") &&
    !event.altKey &&
    !event.shiftKey &&
    !event.ctrlKey &&
    !event.metaKey
  ) {
    focusSearchField();
  }
}

function handleVideoSpeedClick(event) {
  if (!event.shiftKey || event.ctrlKey || event.metaKey) return;

  const video = findCorrespondingVideoElement(event);
  if (!video) return;

  event.preventDefault();
  cycleVideoSpeed(video);
}

function cycleVideoSpeed(video) {
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

  console.log(`%cplayback rate set to ${video.playbackRate}`, "color: purple");
}

function scroll(direction) {
  const distance = (window.innerHeight / 10) * 5;
  const dest =
    direction === "up" ? window.scrollY - distance : window.scrollY + distance;

  animateScroll(window.scrollY, dest);
}

function animateScroll(start, dest) {
  let currentTime = 0;
  const change = dest - start;
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

function copyCurrentURL() {
  navigator.clipboard
    .writeText(window.location.href)
    .then(() => {
      console.log("%cCopied URL to clipboard", "color: purple");
    })
    .catch((err) => {
      console.error("Failed to copy URL:", err);
    });
}

function focusSearchField() {
  let s = document.querySelector('input[type="search"]');
  if (!s) s = document.querySelector('input[type="text"][name="q"]');
  if (!s) s = document.querySelector('input[type="text"][name="search"]');
  if (!s) s = document.querySelector('input[role="search"]');
  if (!s) return;

  console.info("Focusing search input");
  s.focus();
}

function toggleSystemFonts() {
  console.log("toggleSystemFonts");

  if (window.systemFontStyleElement) {
    window.systemFontStyleElement.remove();
    window.systemFontStyleElement = null;
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
  window.systemFontStyleElement = s;
}

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

  document.addEventListener("keydown", (event) => {
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
  linear: function(t) {
    return t;
  },
  // accelerating from zero velocity
  easeInQuad: function(t) {
    return t * t;
  },
  // decelerating to zero velocity
  easeOutQuad: function(t) {
    return t * (2 - t);
  },
  // acceleration until halfway, then deceleration
  easeInOutQuad: function(t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
  },
  // accelerating from zero velocity
  easeInCubic: function(t) {
    return t * t * t;
  },
  // decelerating to zero velocity
  easeOutCubic: function(t) {
    return --t * t * t + 1;
  },
  // acceleration until halfway, then deceleration
  easeInOutCubic: function(t) {
    return t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1;
  },
  // accelerating from zero velocity
  easeInQuart: function(t) {
    return t * t * t * t;
  },
  // decelerating to zero velocity
  easeOutQuart: function(t) {
    return 1 - --t * t * t * t;
  },
  // acceleration until halfway, then deceleration
  easeInOutQuart: function(t) {
    return t < 0.5 ? 8 * t * t * t * t : 1 - 8 * --t * t * t * t;
  },
  // accelerating from zero velocity
  easeInQuint: function(t) {
    return t * t * t * t * t;
  },
  // decelerating to zero velocity
  easeOutQuint: function(t) {
    return 1 + --t * t * t * t * t;
  },
  // acceleration until halfway, then deceleration
  easeInOutQuint: function(t) {
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

function ok() {
  const div = document.createElement("div");
  div.style.cssText = `
    position: fixed;
    bottom: 20px;
    right: 20px;
    background: rgba(0, 0, 0, 0.8);
    backdrop-filter: blur(10px);
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    opacity: 0;
    transform: scale(0.5);
    transition: all 0.2s ease-out;
  `;

  div.innerHTML = `
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
      <polyline points="20 6 9 17 4 12"></polyline>
    </svg>
  `;

  document.body.appendChild(div);

  // Trigger animation
  requestAnimationFrame(() => {
    div.style.opacity = "1";
    div.style.transform = "scale(1)";
  });

  // Remove after delay
  setTimeout(() => {
    div.style.opacity = "0";
    div.style.transform = "scale(0.8)";

    setTimeout(() => {
      div.remove();
    }, 200);
  }, 2000);
}

// Run setup
main();
