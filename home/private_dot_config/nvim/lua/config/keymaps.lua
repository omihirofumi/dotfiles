-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local set = vim.keymap.set
local del = vim.keymap.del

set({ "v", "n" }, "y", '"+y')
set({ "n" }, "Y", '"+y$')
set("n", "<leader>bs", ":Chowcho<CR>", { desc = "Select buffers" })
set("i", "<C-b>", "<Left>")
set("i", "<C-f>", "<Right>")
set("i", "<C-e>", "<End>")
set("n", "<C-w>c", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
set("n", "<C-w><C-c>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

set("n", "<leader>xx", "<Cmd>source %<CR>", { desc = "source %" })

set("n", "<leader>by", ':let @+ = fnamemodify(expand("%"), ":.")<CR>', { desc = "Copy file path" })

del("n", "<C-s>")

vim.api.nvim_create_user_command("RenameIdentifier", function()
  vim.lsp.buf.rename()
end, {})

-- ファイル全体をGitHubで開く
set("n", "<leader>ghf", function()
  local file_path = vim.fn.expand("%")
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")

  local cmd = string.format("gh browse --branch %s %s", branch, file_path)
  vim.fn.system(cmd)
end, { desc = "Open current file in GitHub" })

-- カーソル行をGitHubで開く
set("n", "<leader>ghl", function()
  local line_num = vim.fn.line(".")
  local file_path = vim.fn.expand("%")
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")

  local cmd = string.format("gh browse --branch %s %s:%d", branch, file_path, line_num)
  vim.fn.system(cmd)
end, { desc = "Open current line in GitHub" })

-- 選択範囲をGitHubで開く
set("v", "<leader>ghl", function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local file_path = vim.fn.expand("%")
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local cmd = string.format("gh browse --branch %s %s:%d-%d", branch, file_path, start_line, end_line)
  vim.fn.system(cmd)
end, { desc = "Open selected range in GitHub" })
