;(function() {
  if (!window.__playbackControlsLoaded) {
    document.addEventListener("keyup", function(event) {
      if (event.keyCode === 83 && event.ctrlKey) {
        showControls();
      }
    });
    window.__playbackControlsLoaded = true;
  }

  console.info(
    "%c📺💨 -- press ctrl+s to control video speed",
    "color:green;font-weight:bold"
  );

  function showControls() {
    if (document.getElementById("#speed-controls")) return;

    var video = getVideoElm();
    if (!video) {
      console.info(
        "%c📺💨 -- couldn't locate video element",
        "color:gold;font-weight:bold"
      );
      return;
    }

    var wrapper = createWrapper(video);
    document.body.appendChild(wrapper);
  }

  function removeControls() {
    document.querySelector("#speed-controls").remove();
  }

  function createWrapper(video) {
    var wrapper = document.createElement("div");
    wrapper.id = "speed-controls";

    var display = createDisplay(video.playbackRate);
    var slider = createSlider(display, video);
    var dismissButton = createDismissbutton("OK");

    var controls = document.createElement("div");
    controls.appendChild(slider);
    controls.appendChild(display);
    controls.appendChild(dismissButton);
    applyStyles(controls, {
      background: "#555",
      padding: "20px",
      "border-radius": "20px"
    });

    wrapper.appendChild(controls);

    applyStyles(wrapper, {
      display: "flex",
      "justify-content": "center",
      "align-items": "center",
      position: "absolute",
      top: 0,
      left: 0,
      bottom: 0,
      right: 0,
      "z-index": 100000
    });

    return wrapper;
  }

  function createDisplay(initial) {
    var display = document.createElement("span");
    display.innerText = initial;
    applyStyles(display, {
      color: "#fff",
      "font-family": "monospace",
      margin: "0 10px",
      display: "inline-block",
      width: "30px",
      "text-align": "center"
    });
    return display;
  }

  function createSlider(display, video) {
    var slider = document.createElement("input");
    slider.type = "range";
    slider.min = 0.5;
    slider.max = 2.0;
    slider.step = 0.25;
    slider.value = video.playbackRate;

    slider.oninput = updateDisplay(display);
    slider.onchange = setSpeed(video);

    applyStyles(slider, {
      width: "300px"
    });

    return slider;
  }

  function createDismissbutton(txt) {
    var button = document.createElement("button");
    button.onclick = removeControls;
    button.innerText = txt;
    applyStyles(button, {
      color: "#000"
    });
    return button;
  }

  function updateDisplay(display) {
    return function updateDisplayFn(event) {
      var value = event.target.value;
      display.innerText = value;
    };
  }

  function setSpeed(videoElm) {
    return function setSpeedFn(event) {
      var value = event.target.value;
      videoElm.playbackRate = value;
    };
  }

  function getVideoElm() {
    return document.querySelector(".VideoContainer video");
  }

  function applyStyles(elm, styles) {
    for (var key in styles) {
      elm.style[key] = styles[key];
    }
  }
})();
