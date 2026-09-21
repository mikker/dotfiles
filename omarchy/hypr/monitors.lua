-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- ASUS ROG Swift PG27UCDM: native 4K/240 Hz and 10-bit output. Keep the SDR
-- desktop in sRGB because Chromium/Helium does not yet advertise a P3 Wayland
-- output on this stack; forcing a wide output makes those surfaces appear dim.
-- HDR still switches on for fullscreen HDR content. Keep VRR to fullscreen
-- games so ordinary desktop redraws do not cause OLED flicker.
hl.config({
	misc = { vrr = 3 },
	render = {
		cm_enabled = true,
		send_content_type = true,
		cm_auto_hdr = 1,
	},
})

hl.monitor({
	output = "DP-2",
	mode = "3840x2160@240",
	position = "0x0",
	scale = 1.5,
	bitdepth = 10,
	cm = "srgb",
	supports_wide_color = true,
	supports_hdr = true,
	sdrbrightness = 1.0,
	sdrsaturation = 1.0,
	sdr_min_luminance = 0.2,
	sdr_max_luminance = 200,
	min_luminance = 0.0005,
	max_luminance = 1015,
	max_avg_luminance = 265,
})

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- BEGIN OMARCHY ARM QEMU VIRGL PROFILE
-- QEMU's Cocoa frontend publishes the live window's backing-pixel size and
-- host refresh rate through Virtio GPU EDID. Keep Quattro's preceding automatic
-- monitor rule authoritative so window resizing, Retina/non-Retina displays,
-- fullscreen, and 60/120 Hz hosts remain dynamic. Only hide the guest cursor:
-- Cocoa composes the host cursor outside the guest scanout for immediate motion.
local function omarchy_kernel_option_enabled(expected_option)
	if type(io) ~= "table" or type(io.open) ~= "function" then
		return false
	end

	local opened, cmdline_file = pcall(io.open, "/proc/cmdline", "r")
	if not opened or not cmdline_file then
		return false
	end

	local read_ok, cmdline = pcall(cmdline_file.read, cmdline_file, "*a")
	pcall(cmdline_file.close, cmdline_file)
	if not read_ok or type(cmdline) ~= "string" then
		return false
	end

	for option in cmdline:gmatch("%S+") do
		if option == expected_option then
			return true
		end
	end
	return false
end

if omarchy_kernel_option_enabled("omarchy.qemu_virgl=1") then
	hl.config({ cursor = { invisible = true } })
	o.exec_on_start("/usr/local/bin/omarchy-native-display-sync")
end
-- END OMARCHY ARM QEMU VIRGL PROFILE
