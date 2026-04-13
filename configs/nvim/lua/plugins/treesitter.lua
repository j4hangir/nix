return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup()
    end,
  },
  {
    "daliusd/incr.nvim",
    keys = {
      { ".", mode = { "n", "x" }, desc = "Expand selection" },
      { "<A-.>", mode = "x", desc = "Shrink selection" },
    },
    opts = {
      incr_key = ".",
      decr_key = "<A-.>",
    },
  },
}
