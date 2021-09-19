local utils = require("core.utils")
local rc = require("rc")

local map = utils.map
local maps = rc.mappings
local plugin_maps = maps.plugin

local cmd = vim.cmd

local M = {}

-- mappings to be called during initialization
M.misc = function()
   local function behaviour_mappings()
      -- space bar is leader
      map({ "n", "v" }, " ", "<Nop>")

      -- don't copy the replaced text after pasting in visual mode
      map("v", "p", '"_dP')

      -- allow moving cursor through wrapped lines as default
      map("", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
      map("", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

      -- don't yank on cut
      map({ "n", "v" }, "x", '"_x')
   end

   local function required_mappings()

      -- add Packer commands because we are not loading it at startup
      cmd "silent! command PackerClean lua require 'plugins' require('packer').clean()"
      cmd "silent! command PackerCompile lua require 'plugins' require('packer').compile()"
      cmd "silent! command PackerInstall lua require 'plugins' require('packer').install()"
      cmd "silent! command PackerStatus lua require 'plugins' require('packer').status()"
      cmd "silent! command PackerSync lua require 'plugins' require('packer').sync()"
      cmd "silent! command PackerUpdate lua require 'plugins' require('packer').update()"

   end

   local function user_mappings()

      -- turn off highlighting with ESC
      map("n", maps.no_search_highlight, ":noh <CR>")

      -- for _, map_table in pairs(maps) do
      --    map(unpack(map_table))
      -- end
   end

   behaviour_mappings()
   required_mappings()
   user_mappings()
end

-- plugin related mappings
M.cheatsheet = function()
   local m = plugin_maps.cheatsheet
   map("n", m.default_keys, ":lua require('cheatsheet').show_cheatsheet_telescope() <CR>")
   map("n", m.user_keys, ":lua require('cheatsheet').show_cheatsheet_telescope{ bundled_cheatsheets = false, bundled_plugin_cheatsheets = false } <CR>")
end

M.comment = function()
   local m = plugin_maps.comment.toggle
   map("n", m, ":CommentToggle <CR>")
   map("v", m, ":CommentToggle <CR>")
end

M.telescope = function()
   local m = plugin_maps.telescope
   map("n", m.buffers, ":Telescope buffers <CR>")
   map("n", m.find_files, ":Telescope find_files <CR>")
   map("n", m.file_browser, ":Telescope find_browser <CR>")
   map("n", m.git_commits, ":Telescope git_commits <CR>")
   map("n", m.git_status, ":Telescope git_status <CR>")
   map("n", m.live_grep, ":Telescope live_grep <CR>")
   map("n", m.oldfiles, ":Telescope oldfiles <CR>")
   map("n", m.help_tags, ":Telescope help_tags <CR>")
end

M.window = function()
   local m = plugin_maps.window.pick
   map("n", m, ":lua require('nvim-window').pick() <CR>")
end

return M
