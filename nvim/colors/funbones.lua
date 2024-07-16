local colors_name = "funbones"
vim.g.colors_name = colors_name -- Required when defining a colorscheme

local lush = require("lush")
local hsluv = lush.hsluv -- Human-friendly hsl
local util = require("zenbones.util")

local bg = vim.o.background

-- Define a palette. Use `palette_extend` to fill unspecified colors
-- Based on https://github.com/gruvbox-community/gruvbox#palette
local palette
if bg == "light" then
	palette = util.palette_extend({
		-- bg = hsluv("#f6efe0"),
		-- fg = hsluv("#29285b"),
	}, bg)
else
	palette = util.palette_extend({
		-- bg = hsluv("#1b192e"),
		-- fg = hsluv("#b1bce6"),
	}, bg)
end

-- Generate the lush specs using the generator util
local generator = require("zenbones.specs")
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({ base_specs }).with(function()
	return {
		-- Statement({ base_specs.Statement, fg = palette.rose }),
		-- Special({ fg = palette.water }),
		-- Type({ fg = palette.sky, gui = "italic" }),
	}
end)

-- Pass the specs to lush to apply
lush(specs)

-- Optionally set term colors
require("zenbones.term").apply_colors(palette)
