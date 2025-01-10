-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local set = vim.keymap.set
local del = vim.keymap.del

set({ "v", "n" }, "y", '"+y')
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

del("n", "<C-s>")
