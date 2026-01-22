return {
  {
    "snacks.nvim",
    opts = function(_, opts)
      opts.scroll = { enabled = false }
      opts.explorer = vim.tbl_deep_extend("force", opts.explorer or {}, {
        enabled = false,
        replace_netrw = false,
      })
    end,
  },
}
