local map = vim.keymap.set

-- Dvorak core movement (n, v, o so operators compose: de, ct, yh, etc.)
map({ "n", "v", "o" }, "u", "gk", { desc = "Up" })
map({ "n", "v", "o" }, "e", "gj", { desc = "Down" })
map({ "n", "v", "o" }, "h", "b", { desc = "Back word" })
map({ "n", "v", "o" }, "t", "e", { desc = "End of word" })
map({ "n", "v" }, "=", "h", { desc = "Left" })
map({ "n", "v" }, "+", "l", { desc = "Right" })
map({ "n", "v" }, ",", "_", { desc = "First non-blank" })
map({ "n", "v" }, "<Home>", "_", { desc = "First non-blank" })
map("s", "t", "e", { desc = "End of word (select)" })

-- Displaced operations
map({ "n", "v" }, "f", "u", { desc = "Undo" })
map({ "n", "v" }, "F", "<C-r>", { desc = "Redo" })
map("n", "w", "r", { desc = "Replace char" })
map("n", ";", "p", { desc = "Paste after" })
map("n", "dc", "d$a", { desc = "Delete to EOL + insert" })

-- Insert mode entry
map("n", "<Space>", "i", { desc = "Insert mode" })
map("v", "<Space>", "<Esc>i", { desc = "Exit visual + insert" })
map("n", "<Enter>", "i", { desc = "Insert mode" })

-- Navigation / scrolling
map("n", "]", "<C-e>gj", { desc = "Scroll down" })
map("n", "[", "<C-y>gk", { desc = "Scroll up" })
map("n", ")", "<C-f>", { desc = "Page down" })
map("n", "(", "<C-b>", { desc = "Page up" })
map("n", "{", "[[", { desc = "Code block start" })
map("n", "}", "]]", { desc = "Code block end" })
map("n", "-", "zz", { desc = "Center screen" })

-- Jump list and marks
map({ "n", "v" }, "b", "<C-o>", { desc = "Jump back" })
map({ "n", "v" }, "k", "<C-i>", { desc = "Jump forward" })
map({ "n", "v" }, "'", "`.", { desc = "Jump to last change" })

-- LSP (global — not buffer-local, works when LSP is attached)
map("n", "m", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "q", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "ge", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "gE", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

-- Git hunk navigation (requires gitsigns)
map("n", "g]", function() require("gitsigns").next_hunk() end, { desc = "Next git change" })
map("n", "g[", function() require("gitsigns").prev_hunk() end, { desc = "Prev git change" })
map("n", "gk", ":<C-u>!git add -A && git commit -m 'wip' && git push<CR>", { desc = "Git commit + push" })

-- Commenting: handled by Comment.nvim (gc/gC)

-- Visual mode extras
map("v", "g", "t", { desc = "Till char forward" })
map("v", "G", "T", { desc = "Till char backward" })
map("v", "T", "G", { desc = "Go to last line" })

-- Insert / command mode helpers
map("n", "<C-a>", "0", { desc = "Go to column 0" })
map("i", "<C-a>", "<Esc>I", { desc = "Go to line start" })
map("i", "<Home>", "<Esc>I", { desc = "Go to line start" })
map("c", "<C-v>", "<C-r>+", { desc = "Paste from clipboard" })

-- Window navigation (Ctrl-modified — no conflict with Dvorak bare keys)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Bookmarks via native marks
map("n", "#", function()
  local char = vim.fn.getcharstr()
  if char and char ~= "" then
    vim.cmd("normal! m" .. char)
  end
end, { desc = "Set mark" })

-- Leader mappings
map("n", "<leader>n", "<cmd>nohlsearch<cr>", { desc = "Clear search" })
map("n", "<leader>q", "gqip", { desc = "Format paragraph" })
map("n", "<leader>l", "<cmd>set list!<cr>", { desc = "Toggle list chars" })

-- Run current file (filetype-aware)
map("n", "r", function()
  local ft = vim.bo.filetype
  local runners = {
    python = "python3 %",
    go = "go run %",
    javascript = "node %",
    typescript = "npx ts-node %",
    rust = "cargo run",
    lua = "lua %",
    bash = "bash %",
    sh = "sh %",
    zsh = "zsh %",
  }
  local cmd = runners[ft]
  if cmd then
    vim.cmd("!" .. cmd)
  else
    vim.notify("No runner for filetype: " .. ft, vim.log.levels.WARN)
  end
end, { desc = "Run current file" })

-- Misc
map("n", "<A-m>", "/^if __name__ == '__main__'<CR>", { desc = "Find __main__" })
map("n", "gf", [[:s/\%#\(\w\+\)/\=submatch(1) ==# 'True' ? 'False' : submatch(1) ==# 'False' ? 'True' : submatch(1) ==# 'true' ? 'false' : submatch(1) ==# 'false' ? 'true' : submatch(1)/<CR>]], { desc = "Toggle boolean", silent = true })

-- Restore cursor to last position on file open
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lines = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
