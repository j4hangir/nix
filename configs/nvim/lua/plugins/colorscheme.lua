return {
  "marko-cerovac/material.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.material_style = "darker"
    require("material").setup({
      contrast = {
        sidebars = true,
        floating_windows = true,
        cursor_line = true,
      },
      plugins = {
        "flash",
        "gitsigns",
        "nvim-cmp",
        "telescope",
        "which-key",
      },
    })
    vim.cmd.colorscheme("material")
  end,
}
