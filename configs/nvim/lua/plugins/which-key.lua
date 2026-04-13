return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>f", group = "Find" },
      { "<leader>h", group = "Git hunks" },
      { "<leader>r", group = "Refactor" },
      { "<leader>c", group = "Code" },
      { "g", group = "Go to / Git" },
      { "<leader>o", group = "Organize" },
    })
  end,
}
