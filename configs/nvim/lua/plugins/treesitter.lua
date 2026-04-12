return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter").setup({
      auto_install = true,
      ensure_installed = {
        "lua", "python", "javascript", "typescript", "bash",
        "json", "yaml", "html", "css", "go", "rust", "c",
        "markdown", "vimdoc",
      },
    })
  end,
}
