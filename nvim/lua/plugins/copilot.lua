return {
  {
    url = "https://github.com/github/copilot.vim",
    cond = false,
    init = function(p)
      if not p.cond then
        return
      end
      vim.g.copilot_no_tab_map = true
    end,
    config = function()
      vim.keymap.set("i", "<C-X>a", function()
        vim.notify(vim.inspect(vim.fn["copilot#GetDisplayedSuggestion"]()))
      end)
      vim.keymap.set("i", "<C-N>", "<Plug>(copilot-next)")
      vim.keymap.set("i", "<C-P>", "<Plug>(copilot-previous)")
      vim.keymap.set("i", "<C-X>l", "<Plug>(copilot-accept-line)")
      vim.keymap.set("i", "<C-X>w", "<Plug>(copilot-accept-word)")
      vim.keymap.set("i", "<C-A>", function()
        local s = vim.fn["copilot#GetDisplayedSuggestion"]()
        if s.deleteSize == 0 and s.text == "" and s.outdentSize == 0 then
          return vim.keycode("<Plug>(copilot-suggest)")
        end
        return vim.fn["copilot#Accept"]("\\<CR>")
      end, {
        expr = true,
        replace_keycodes = false,
      })
    end,
  },
  {
    url = "https://github.com/zbirenbaum/copilot.lua",
    -- cond = false,
    cmd = "Copilot",
    event = { "InsertEnter", "CursorHold" },
    config = function()
      require("copilot").setup({
        suggestion = {
          -- auto_trigger = true,
          auto_trigger = false,
          keymap = {
            accept = false,
            accept_line = "<C-X>l",
            accept_word = "<C-X>w",
            next = "<C-N>",
            prev = "<C-P>",
          },
        },
        filetypes = { ["*"] = true },
      })
      vim.keymap.set("i", "<c-a>", function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        else
          require("copilot.suggestion").next()
        end
      end)
    end,
  },
  {
    url = "https://github.com/olimorris/codecompanion.nvim",
    lazy = true,
    event = "CmdlineEnter",
    init = function()
      vim.keymap.set({ "n", "x" }, "<c-s><c-s>", ":CodeCompanionChat ")
      vim.keymap.set({ "n", "x" }, "<c-s><c-i>", ":CodeCompanion ")
    end,
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "copilot",
            keymaps = {
              yank_code = {
                modes = {
                  n = "<Plug>(ignored)",
                },
                index = 7,
                callback = "keymaps.yank_code",
                description = "Yank Code",
              },
            },
          },
          inline = {
            adapter = "copilot",
          },
          agent = {
            adapter = "copilot",
          },
        },
        display = {
          action_palette = {
            provider = "telescope",
          },
        },
      })
    end,
  },
}
