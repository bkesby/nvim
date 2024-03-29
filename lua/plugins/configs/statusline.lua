local present, statusline = pcall(require, "feline")
if not present then return end

local lsp = require "feline.providers.lsp"
local cursor = require "feline.providers.cursor"
local vimode_utils = require "feline.providers.vi_mode"

local colors = require("onedarkpro.helpers").get_colors("onedark")

local vi_mode_colors = {
   NORMAL = colors.white,
   INSERT = colors.green,
   VISUAL = colors.purple,
   OP = colors.white,
   BLOCK = colors.blue,
   REPLACE = colors.red,
   ["V-REPLACE"] = colors.red,
   ENTER = colors.cyan,
   MORE = colors.cyan,
   SELECT = colors.orange,
   COMMAND = colors.green,
   SHELL = colors.green,
   TERM = colors.green,
   NONE = colors.yellow,
}

local vimode_hl = function()
   return {
      name = vimode_utils.get_mode_highlight_name(),
      fg = vimode_utils.get_mode_color(),
   }
end

local properties = {
   force_inactive = {
      filetypes = { "Dashboard", "packer", "fugitive", "fugitiveblame" },
   },
}

local comps = {
   vi_mode = {
      left = { provider = "▊", right_sep = " ", hl = vimode_hl },
      right = { provider = "▊", left_sep = " ", hl = vimode_hl },
   },
   directory = {
      provider = function()
         local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
         return " " .. dir_name .. " "
      end,
      enabled = function() return vim.api.nvim_win_get_width(0) > 80 end,
      hl = { style = "bold" },
   },
   filename = {
      provider = function()
         local filename = vim.fn.expand "%:t"
         local extension = vim.fn.expand "%:e"
         local icon = require("nvim-web-devicons").get_icon(filename, extension)
         if icon == nil then
            icon = " "
            return icon
         end
         return icon .. " " .. filename .. " "
      end,
      enabled = function() return vim.api.nvim_win_get_width(0) > 70 end,
      left_sep = " ",
   },
   diagnostics = {
      error = {
         provider = "diagnostic_errors",
         enabled = function() return lsp.diagnostics_exist "ERROR" end,
         -- icon = "  ",
         -- hl = "LspDiagnosticsDefaultError",
      },
      warning = {
         provider = "diagnostic_warnings",
         enabled = function() return lsp.diagnostics_exist "WARN" end,
         icon = "  ",
         -- hl = "LspDiagnosticsDefaultWarning",
      },
      hint = {
         provider = "diagnostic_hints",
         enabled = function() return lsp.diagnostics_exist "HINT" end,
         icon = "  ",
         -- hl = "LspDiagnosticsDefaultHint",
      },
      info = {
         provider = "diagnostic_info",
         enabled = function() return lsp.diagnostics_exist "INFO" end,
         icon = "  ",
         -- hl = "LspDiagnosticsDefaultInformation",
      },
   },
   lsp = {
      provider = function()
         local Lsp = vim.lsp.util.get_progress_messages()[1]
         if Lsp then
            local msg = Lsp.message or ""
            local percentage = Lsp.percentage or 0
            local title = Lsp.title or ""
            local spinners = { "", "", "" }
            local success_icon = { "", "", "" }
            local ms = vim.loop.hrtime() / 100000
            local frame = math.floor(ms / 120) % #spinners

            if percentage >= 70 then
               return string.format(" %%<%s %s (%s%%%%) ",
                                    success_icon[frame + 1], title, msg,
                                    percentage)
            else
               return string.format(" %%<%s %s (%s%%%%) ", spinners[frame + 1],
                                    title, msg, percentage)
            end
         end
         local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
         local clients = vim.lsp.get_active_clients()
         for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
               return " " .. client.name
            end
         end
         return " ﭥ "
      end,
      enabled = function() return vim.api.nvim_win_get_width(0) > 80 end,
      hl = { fg = colors.yellow },
   },
   git = {
      branch = {
         provider = "git_branch",
         enabled = function() return vim.api.nvim_win_get_width(0) > 70 end,
         icon = "  ",
         left_sep = " ",
         hl = { fg = colors.purple, style = "bold" },
      },
      diff = {
         added = {
            provider = "git_diff_added",
            icon = "  ",
            -- hl = "GitAddStatus",
         },
         changed = {
            provider = "git_diff_changed",
            icon = " 柳",
            -- hl = "GitChange",
         },
         deleted = {
            provider = "git_diff_removed",
            icon = "  ",
            -- hl = "GitDelete",
         },
      },
   },
   position = {
      provider = function() return cursor.position() end,
      left_sep = " ",
   },
}

local components = { active = { {}, {}, {} }, inactive = {} }

-- left
table.insert(components.active[1], comps.vi_mode.left)
table.insert(components.active[1], comps.directory)
table.insert(components.active[1], comps.filename)
table.insert(components.active[1], comps.diagnostics.error)
table.insert(components.active[1], comps.diagnostics.warning)
table.insert(components.active[1], comps.diagnostics.hint)
table.insert(components.active[1], comps.diagnostics.info)

-- mid
table.insert(components.active[2], comps.lsp)

-- right
table.insert(components.active[3], comps.git.diff.added)
table.insert(components.active[3], comps.git.diff.changed)
table.insert(components.active[3], comps.git.diff.deleted)
table.insert(components.active[3], comps.git.branch)
-- table.insert(components.active[3], comps.position)
table.insert(components.active[3], comps.vi_mode.right)

statusline.setup({
   colors = { fg = colors.fg_statusline, bg = colors.bg_statusline },
   components = components,
   properties = properties,
   vi_mode_colors = vi_mode_colors,
})
