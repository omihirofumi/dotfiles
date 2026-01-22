return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  opts = function(_, opts)
    local cmp = require("cmp")

    opts.sources = {
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
      { name = "snippets" },
      { name = "copilot" },
    }

    return opts
  end,
}
