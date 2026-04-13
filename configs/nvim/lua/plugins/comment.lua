return {
  "numToStr/Comment.nvim",
  keys = {
    { "gc", mode = { "n", "v" }, desc = "Line comment" },
    { "gC", mode = { "n", "v" }, desc = "Block comment" },
  },
  opts = {
    toggler = { line = "gcc", block = "gCC" },
    opleader = { line = "gc", block = "gC" },
  },
}
