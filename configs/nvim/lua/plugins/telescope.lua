return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<Tab>", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "p", "<cmd>Telescope lsp_document_symbols<cr>", desc = "File structure" },
    { "_", "<cmd>Telescope marks<cr>", desc = "Show bookmarks" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    require("telescope").load_extension("fzf")
  end,
}
