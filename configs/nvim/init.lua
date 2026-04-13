local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("options")
require("keymaps")
require("lazy").setup("plugins", {
  install = { missing = true },
  change_detection = { notify = false },
})

-- Auto-close lazy UI after first-time install
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyInstall",
  once = true,
  callback = function()
    vim.cmd.close()
  end,
})
