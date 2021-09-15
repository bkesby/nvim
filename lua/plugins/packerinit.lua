local cmd = vim.cmd

cmd "packadd packer.nvim"

local present, packer = pcall(require, "packer")

-- install packer on new system
if not present then
   local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

   print "Cloning packer..."
   -- remove the dir before cloning
   vim.fn.delete(install_path, "rf")
   vim.fn.system({
         "git",
         "clone",
         "https://github.com/wbthomason/packer.nvim",
         "--depth",
         "1",
         install_path,
   })
   
   cmd "packadd packer.nvim"
   present, packer = pcall(require, "packer")

   if present then
      print "Packer cloned successfully."
   else
      error("Couldn't clone packer!\nPacker path: " .. packer_path .. "\n" .. packer)
   end
end

-- initialize packer with custom settings
packer.init {
   display = {
      open_fn = function()
         return require("packer.util").float { border = "single" }
      end,
      prompt_border = "single",
   },
   git = {
      clone_timeout = 600,
   },
   auto_clean = true,
   compile_on_sync = true,
}

return packer
