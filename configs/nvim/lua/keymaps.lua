local map = vim.keymap.set

map("n", "j", "gj", { silent = true })
map("n", "k", "gk", { silent = true })

map("n", "<leader><space>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })
map("n", "<leader>q", "gqip", { desc = "Format paragraph" })
map("n", "<leader>l", "<cmd>set list!<cr>", { desc = "Toggle list chars" })

map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lines = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
