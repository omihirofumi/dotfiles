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

del("n", "<C-s>")
