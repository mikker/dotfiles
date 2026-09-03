local focus_blue = "rgb(1853c7)"
local transparent = "rgba(ffffff22)"

-- Mekanikos Light owns its rounded client shape and focus ring. Hyprland's
-- native border tracks focus; borders-plus-plus is static and paints every window.
hl.config({
	general = {
		border_size = 4,
		gaps_in = 2,
		gaps_out = 12,
		col = {
			active_border = focus_blue,
			inactive_border = transparent,
		},
	},

	decoration = {
		border_part_of_window = true,
		rounding = 14,
		rounding_power = 2,
		shadow = {
			enabled = true,
			range = 18,
			render_power = 2,
			sharp = false,
			color = "rgba(10131a18)",
			color_inactive = "rgba(10131a0d)",
			offset = { 0, 4 },
			scale = 1.0,
		},
		glow = {
			enabled = false,
		},
		blur = {
			enabled = true,
			size = 16,
			passes = 3,
			ignore_opacity = true,
			new_optimizations = true,
			noise = 0.01,
			contrast = 0.96,
			brightness = 1.04,
			-- A restrained macOS-like saturation lift behind material surfaces.
			vibrancy = 0.12,
			vibrancy_darkness = 0.05,
			popups = true,
			popups_ignorealpha = 0.30,
		},
	},

	group = {
		col = {
			border_active = focus_blue,
			border_inactive = transparent,
		},
	},

	plugin = {
		borders_plus_plus = {
			add_borders = 0,
			natural_rounding = false,
			border_size_1 = 4,
			col = {
				border_1 = focus_blue,
			},
		},
	},
})

-- Blur only the painted parts of Omarchy Shell's menu and popover layers.
hl.layer_rule({
	match = {
		namespace = "^(omarchy-bar|omarchy-menu|omarchy-emojis|omarchy-clipboard|omarchy-keyboard-panel|omarchy-reminders|omarchy-osd|omarchy-notifications|omarchy-polkit|omarchy-network-qr)$",
	},
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.30,
})

-- Omarchy gives normal windows a small amount of opacity by default. Keep the
-- material blur exclusive to the shell layers selected above.
o.window(".*", { no_blur = true })

-- Keep the gallery canvas opaque while allowing its actual popup controls to
-- preview material blur.
o.window({ class = "^org.quickshell$", title = "^Omarchy shell – dev gallery$" }, {
	tag = "-default-opacity",
	opacity = "1 1",
	no_blur = false,
})
