local present, treesitter = pcall(require, "nvim-treesitter.configs")
if not present then return end

treesitter.setup {
   ensure_installed = { "css", "html", "javascript", "lua", "python", "rust" },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
   indent = {
      enable = true,
   },
   autotag = {
      enabled = true,
   },
   textsubjects = {
      enable = true,
      keymaps = {
         ["."] = "textsubjects-smart",
         [";"] = "textsubjects-container-outer",
      },
   },
}
