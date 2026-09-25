hl.config({
  input = {
    repeat_rate = 30,
    repeat_delay = 350,
    sensitivity = 0.33,
    accel_profile = "flat",
    natural_scroll = true,
    touchpad = {
      -- Keep physical scrolling at libinput's normal speed. FlickRing scales
      -- only its own synthetic continuous-axis events via scroll_speed.
      scroll_factor = 1.0,
    },
  },
})
