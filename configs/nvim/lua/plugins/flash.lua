return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    { "i", function() require("flash").jump() end, mode = { "n", "x" }, desc = "Flash jump" },
    { "<leader>j", function()
      require("flash").jump({
        search = { mode = "search" },
        label = { after = false, before = true },
        pattern = "^",
      })
    end, mode = { "n", "x", "o" }, desc = "Flash line jump" },
  },
  opts = {
    modes = {
      char = { enabled = false },   -- f/F/t/T are remapped in Dvorak
      search = { enabled = false },
    },
  },
}
