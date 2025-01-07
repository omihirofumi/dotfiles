return {
  { url = "https://github.com/vim-denops/denops.vim" },
  { url = "https://github.com/lambdalisue/kensaku.vim" },
  {
    -- search
    url = "https://github.com/atusy/jab.nvim",
    -- dev = true,
    lazy = true,
    init = function()
      vim.keymap.set({ "n", "x", "o" }, "f", function()
        return require("jab").f()
      end, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", function()
        return require("jab").F()
      end, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", function()
        return require("jab").t()
      end, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", function()
        return require("jab").T()
      end, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, ";", function()
        return require("jab").jab_win()
      end, { expr = true })
    end,
  },
  {
    url = "https://github.com/atusy/treemonkey.nvim",
    init = function()
      vim.keymap.set({ "x", "o" }, "m", function()
        require("treemonkey").select({ ignore_injections = false })
      end)
    end,
  },
}
