local cmd = vim.cmd

local colors = require("colors").get()
local theme = colors.name

-- collect the hex values
local black = "#" .. colors.base00
local black2 = "#" .. colors.base01
local blue = "#" .. colors.base02
local darker_black = "#" .. colors.base03
local folder_bg = "#" .. colors.base04
local green = "#" .. colors.base05
local grey = "#" .. colors.base06
local grey_fg = "#" .. colors.base07
local line = "#" .. colors.base08
local nord_blue = "#" .. colors.base09
local one_bg = "#" .. colors.base0A
local one_bg2 = "#" .. colors.base0B
local pmenu_bg = "#" .. colors.base0C
local purple = "#" .. colors.base0D
local red = "#" .. colors.base0E
local white = "#" .. colors.base0F
-- local yellow = "#" .. colors.base0G

-- collect configuration
local ui = require("rc").ui

-- command functions
local function fg(group, color)
   cmd("hi " .. group .. " guifg=" .. color)
end
local function bg(group, color)
   cmd("hi " .. group .. " guibg=" .. color)
end
local function fgbg(group, fcolor, bcolor)
   cmd("hi " .. group .. " guifg=" .. fcolor .. " guibg=" .. bcolor)
end

-- Comments
fg("Comment", darker_black)

-- Theme specifics
if theme == "heetch" then
   fg("SpecialChar", one_bg)
   fg("Delimiter", darker_black)
end

-- Disable cursor line
cmd [[ hi clear CursorLine ]]

-- Gutters
fgbg("LineNR", darker_black, black)
fgbg("CursorLineNR", nord_blue, black .. " gui=bold")
bg("FoldColumn", black)
bg("SignColumn", black)

-- Dividers
fgbg("VertSplit", black2, black)

-- Folds
bg("Folded", black)

-- Plugins
-- blankline
fg("IndentBlanklineChar", black2)
fg("IndentBlanklineContextChar", white .. " gui=nocombine")