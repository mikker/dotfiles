-- Pull tiled windows closer to the bar while preserving the other outer gaps.
hl.config({
  general = {
    gaps_out = { top = 4, right = 12, bottom = 12, left = 12 },
  },
})

-- Frost the translucent Omarchy OSD card without blurring the transparent
-- fullscreen layer around it.
hl.layer_rule({
  name = "frosted-omarchy-osd",
  match = { namespace = "^omarchy-osd$" },
  blur = true,
  ignore_alpha = 0.08,
})
