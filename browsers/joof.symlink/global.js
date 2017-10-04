// Let's me scroll by half a page instead of a whole page (space bar)
// Bound to ctrl+d and ctrl+u -- like in vim
setupScrollByCtrlDAndU();

// Speed up any <video> by shift-clicking on it
// Every click bumps the speed by .25 until it resets
//   eg. 1 -> 1.25 -> 1.5 -> 1
setupVideoSpeedThing();

function setupVideoSpeedThing() {
  document.addEventListener("mouseup", event => {
    if (!event.shiftKey || event.ctrlKey || event.metaKey) return;

    const video = findCorrespondingVideoElement(event);
    if (!video) return;

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

  function findCorrespondingVideoElement(event) {
    if (event.target.tagName === "VIDEO") return event.target;

    // vimeo
    const vimeo = event.target.ownerDocument.querySelector(".video video");
    if (vimeo) return vimeo;

    return undefined;
  }
}

function setupScrollByCtrlDAndU() {
  document.addEventListener("keydown", event => {
    if (onlyCtrl(event) && event.keyCode === 68) {
      scroll("down");
    } else if (onlyCtrl(event) && event.keyCode === 85) {
      scroll("up");
    }
  });

  function scroll(direction) {
    const distance = window.innerHeight / 10 * 5;

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
    const duration = 200;

    function tick() {
      currentTime += increment;

      document.scrollingElement.scrollTo(
        0,
        easeInOutQuad(currentTime, start, change, duration)
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

  function easeInOutQuad(t, b, c, d) {
    t /= d / 2;

    if (t < 1) {
      return c / 2 * t * t + b;
    }

    t--;

    return -c / 2 * (t * (t - 2) - 1) + b;
  }
}
