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
        "markdown", "vimdoc", "nix",
      },
    })

    -- Incremental selection via treesitter nodes
    local sel_node = nil
    vim.keymap.set({ "n", "x" }, ".", function()
      local node = sel_node and sel_node:parent() or vim.treesitter.get_node()
      if not node then return end
      sel_node = node
      local sr, sc, er, ec = node:range()
      vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
      vim.cmd("normal! v")
      vim.api.nvim_win_set_cursor(0, { er + 1, ec > 0 and ec - 1 or 0 })
    end, { desc = "Expand selection" })

    vim.keymap.set("x", "<A-.>", function()
      if not sel_node then return end
      -- Find a smaller child node near cursor
      local cursor = vim.api.nvim_win_get_cursor(0)
      local child = vim.treesitter.get_node({ pos = { cursor[1] - 1, cursor[2] } })
      if child and child ~= sel_node then
        sel_node = child
        local sr, sc, er, ec = child:range()
        vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
        vim.cmd("normal! v")
        vim.api.nvim_win_set_cursor(0, { er + 1, ec > 0 and ec - 1 or 0 })
      end
    end, { desc = "Shrink selection" })

    -- Reset selection tracking when leaving visual mode
    vim.api.nvim_create_autocmd("ModeChanged", {
      pattern = "[vV\x16]*:n",
      callback = function() sel_node = nil end,
    })
  end,
}
