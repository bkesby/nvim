local cmd = vim.cmd
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Autocommand to reload neovim on plugin init file save
cmd [[
   augroup packer_user_config
      autocmd!
      autocmd BufWritePost plugins/init.lua source <afile> | PackerSync
   augroup end
]]

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
cmd [[
   let ignore_filetypes = ["dashboard", "terminal"]
   au InsertEnter * if index(ignore_filetypes, &ft) < 0 | set nornu
   au InsertLeave * if index(ignore_filetypes, &ft) < 0 | set rnu
]]

-- Hide statusline
cmd [[ au BufEnter,BufWinEnter,FileType,WinEnter * lua require("core.utils").hide_statusline() ]]

-- Hide line numbers inside terminal
cmd [[ au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal ]]

-- Hide bufferline inside dashboard
cmd [[ autocmd FileType dashboard setlocal showtabline=0 nonu nornu nocul ]]

-- Filetype specifics
cmd [[ au Filetype lua setlocal tabstop=3 shiftwidth=3 softtabstop=3 ]]
cmd [[ au Filetype svelte setlocal tabstop=2 shiftwidth=2 softtabstop=2 ]]
cmd [[ au FileType markdown setlocal wrap ]]
cmd [[ au FileType wiki setlocal wrap ]]
cmd [[ au FileType nix setlocal tabstop=2 shiftwidth=2 softtabstop=2 ]]

-- Auto format on save
-- cmd [[
-- augroup fmt
--    autocmd!
--    autocmd BufWritePre *.lua,*.py,*.rs silent! undojoin | silent! Neoformat
-- augroup END
-- ]]


-- Yank highlight confirmation
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
   group = 'YankHighlight',
   callback = function()
      vim.highlight.on_yank { higroup="IncSearch", timeout="1000" }
   end
})

-- Lightbulb code action hint
cmd [[
augroup lightbulb
   autocmd!
   au CursorHold,CursorHoldI *.py,*.lua,*.rs,*.svelte lua require'nvim-lightbulb'.update_lightbulb()
augroup END
]]

-- Enter insert mode when switching to terminal
autocmd('TermOpen', {
   pattern = '*',
   command = 'startinsert',
})
