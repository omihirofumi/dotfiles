-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("config.lazy")
require("lspconfig").pyright.setup({
  settings = {
    python = {
      venvPath = ".",
      pythonPath = "./.venv/bin/python",
      analysis = {
        extraPaths = { "." },
      },
    },
  },
})

vim.cmd("colorscheme kanagawa")
