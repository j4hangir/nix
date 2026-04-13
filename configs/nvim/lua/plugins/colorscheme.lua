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
        colors.editor.bg = "#121212"
        colors.editor.bg_alt = "#0a0a0a"
        colors.backgrounds.sidebars = "#0e0e0e"
        colors.backgrounds.floating_windows = "#161616"
        colors.backgrounds.cursor_line = "#1a1a1a"
      end,
    })
    vim.cmd.colorscheme("material")
  end,
}
