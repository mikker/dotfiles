local colors_name = "zenbones-mikker"
vim.g.colors_name = colors_name

local lush = require("lush")
local hsluv = lush.hsluv -- Human-friendly hsl
local zenbones = require("zenbones")
local util = require("zenbones.util")

local bg = vim.o.background

-- Define a palette. Use `palette_extend` to fill unspecified colors
-- Based on https://github.com/gruvbox-community/gruvbox#palette
local palette
if bg == "light" then
	palette = util.palette_extend({
		bg = hsluv("#ddd6d3"),
		fg = hsluv("#1E1C31"),
		rose = hsluv("#F02E6E"),
		leaf = hsluv("#7FE9C3"),
		wood = hsluv("#F2B482"),
		water = hsluv("#78A8FF"),
		blossom = hsluv("#7676FF"),
		sky = hsluv("#63F2F1"),
	}, bg)
else
	palette = util.palette_extend({
		bg = hsluv("#2D2B40"),
		fg = hsluv("#CBE3E7"),
		rose = hsluv("#F48FB1"),
		leaf = hsluv("#A1EFD3"),
		wood = hsluv("#FFE6B3"),
		water = hsluv("#91DDFF"),
		blossom = hsluv("#D4BFFF"),
		sky = hsluv("#ABF8F7"),
	}, bg)
end

-- Generate the lush specs using the generator util
local generator = require("zenbones.specs")
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({ base_specs }).with(function()
	return {

		NeotestTest({ zenbones.Normal }),
		NeotestPassed({ zenbones.diffAdded, gui = "bold" }),
		NeotestFailed({ zenbones.diffRemoved }),
		NeotestRunning({ zenbones.diffLine }),
		NeotestSkipped({ zenbones.DiagnosticHint }),
		NeotestFocused({ zenbones.Normal, gui = "underline,bold" }),
		NeotestFile({ zenbones.Function }),
		NeotestDir({ zenbones.Directory }),
		NeotestIndent({ zenbones.LineNr }),
		NeotestExpandMarker({ zenbones.LineNr }),
		NeotestAdapterName({ zenbones.Function }),
		NeotestWinSelect({ zenbones.Normal }),
		NeotestMarked({ zenbones.Normal }),
		NeotestTarget({ zenbones.Normal }),
		NeotestUnknown({ zenbones.Normal }),
	}
end)

lush(specs)

require("zenbones.term").apply_colors(palette)
