-- Keymaps are automatically loaded on the VeryLazy event
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local set = vim.keymap.set
local del = vim.keymap.del
local permalink = require("util.permalink")
local jj_diff = require("jj_diff")

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

jj_diff.setup()

-- GitHub関連（関数を外部ファイルから読込）
set("n", "<leader>gho", permalink.open_github, { desc = "Open github in browser" })
set("n", "<leader>ghf", permalink.open_github_file, { desc = "Open current file in GitHub" })
set("n", "<leader>ghl", permalink.open_github_line, { desc = "Open current line in GitHub" })
set("v", "<leader>ghl", permalink.open_github_range, { desc = "Open selected range in GitHub" })

-- パーマリンク生成（関数を外部ファイルから読込）
set({ "n", "v" }, "<leader>cP", permalink.copy_relative_permalink, {
  desc = "Copy relative permalink for prompt",
})

set("n", "<leader>jj", ":JjDiffUI<CR>", { desc = "JJ diff: UI" })
