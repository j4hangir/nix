return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      ensure_installed = {
        "lua", "python", "javascript", "typescript", "bash",
        "json", "yaml", "html", "css", "go", "rust", "c",
        "markdown", "vimdoc", "nix",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = ".",
          node_incremental = ".",
          node_decremental = "<A-.>",
          scope_incremental = false,
        },
      },
    })
  end,
}
