local present1, lspconfig = pcall(require, "lspconfig")
local present2, lspinstall = pcall(require, "nvim-lsp-installer")
local present3, coq = pcall(require, "coq")

if not (present1 or present2 or present3) then return end

-- Neodev setup
require("neodev").setup({})

local maps = require('maps').plugin.lsp
local set_keymap = vim.api.nvim_set_keymap

local opts = { noremap=true, silent=true }

set_keymap('n', maps.open_float, '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
set_keymap('n', maps.goto_prev, '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
set_keymap('n', maps.goto_next, '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
set_keymap('n', maps.set_loclist, '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- use attach function to only map keys after language server attaches to current buffer
local on_attach = function(client, bufnr)
   local buf_opts = { noremap=true, silent=true, buffer=bufnr }
   local function buf_set_keymap(...) vim.keymap.set(...) end

   -- see `:help vim.lsp.*` for documentation on any of the below functions
   buf_set_keymap("n", maps.declaration, vim.lsp.buf.declaration, buf_opts)
   buf_set_keymap("n", maps.definition, vim.lsp.buf.definition, buf_opts)
   buf_set_keymap("n", maps.hover, vim.lsp.buf.hover, buf_opts)
   buf_set_keymap("n", maps.implementation, vim.lsp.buf.implementation, buf_opts)
   buf_set_keymap("n", maps.signature_help, vim.lsp.buf.signature_help, buf_opts)
   buf_set_keymap("n", maps.add_workspace_folder, vim.lsp.buf.add_workspace_folder, buf_opts)
   buf_set_keymap("n", maps.remove_workspace_folder, vim.lsp.buf.remove_workspace_folder, buf_opts)
   buf_set_keymap("n", maps.list_workspace_folders, function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
   end, buf_opts)
   buf_set_keymap("n", maps.type_definition, vim.lsp.buf.type_definition, buf_opts)
   buf_set_keymap("n", maps.rename, vim.lsp.buf.rename, buf_opts)
   buf_set_keymap("n", maps.code_action, vim.lsp.buf.code_action, buf_opts)
   buf_set_keymap("n", maps.references, vim.lsp.buf.references, buf_opts)
   buf_set_keymap("n", maps.format, vim.lsp.buf.format, buf_opts)

   local handlers = vim.lsp.handlers
   -- extended lsp utils
   handlers["textDocument/codeAction"] = require"lsputil.codeAction".code_action_handler
   handlers["textDocument/references"] = require"lsputil.locations".references_handler
   handlers["textDocument/definition"] = require"lsputil.locations".definition_handler
   handlers["textDocument/declaration"] = require"lsputil.locations".declaration_handler
   handlers["textDocument/typeDefinition"] = require"lsputil.locations".typeDefinition_handler
   handlers["textDocument/implementation"] = require"lsputil.locations".implementation_handler
   handlers["textDocument/documentSymbol"] = require"lsputil.symbols".document_handler
   handlers["workspace/symbol"] = require"lsputil.symbols".workspace_handler

end

-- diagnostics symbols
local signs = {
   Error = " ",
   Warn = " ",
   Info = " ",
   Hint = " ",
}

for type, icon in pairs(signs) do
   local hl = "DiagnosticSign" .. type
   vim.fn.sign_define(hl, {
      text = icon,
      texthl = hl,
      numhl = "",
   })
end

-- UI
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
   virtual_text = {
      prefix = " ",
      spacing = 3,
      severity_limit = "Warning",
   },
   signs = true,
   underline = false,
   update_in_insert = false,
})

local servers = {
   "bashls",
   "cssls",
   "dockerls",
   "eslint",
   "html",
   "jsonls",
   "tsserver",
   "sumneko_lua",
   "phpactor",
   "pyright",
   "rust_analyzer",
   "sqlls",
   "svelte",
   "taplo",
   "yamlls",
}

-- nvim-lsp-installer
lspinstall.setup {
   ensure_installed = servers,
   automatic_installation = true,
}

-- LSP config server setup
for _, server in pairs(servers) do
   local server_opts = { on_attach = on_attach }

   lspconfig[server].setup(coq.lsp_ensure_capabilities(server_opts))
end
