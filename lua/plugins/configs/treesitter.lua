local present, treesitter = pcall(require, "nvim-treesitter.configs")
if not present then
   return
end

treesitter.setup {
   ensure_installed = {
      "css",
      "html",
      "javascript",
      "lua",
      "python",
   },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
}