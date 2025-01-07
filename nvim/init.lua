-- bootstrap lazy.nvim, LazyVim and your plugins
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
