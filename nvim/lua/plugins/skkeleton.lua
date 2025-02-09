return {
  "vim-skk/skkeleton",
  init = function()
    vim.keymap({ "i" }, "<C-j>", "<Plug>(skkeleton-enable")
  end,
}
