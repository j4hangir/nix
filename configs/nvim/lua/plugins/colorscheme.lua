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
      custom_colors = function(colors)
        colors.editor.bg = "#000000"
        colors.editor.bg_alt = "#030303"
        colors.backgrounds.sidebars = "#000000"
        colors.backgrounds.floating_windows = "#050505"
        colors.backgrounds.cursor_line = "#0a0a0a"
      end,
    })
    vim.cmd.colorscheme("material")
  end,
}
