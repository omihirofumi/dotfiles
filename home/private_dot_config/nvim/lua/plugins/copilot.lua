return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = { "InsertEnter", "CursorHold" },
  opts = {
    copilot_node_command = vim.fn.expand("~/.local/share/mise/installs/node/25.4.0/bin/node"),
  },
  config = function(_, opts)
    require("copilot").setup(vim.tbl_deep_extend("force", opts, {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = false,
          accept_line = "<C-X>l",
          accept_word = "<C-X>w",
          next = "<C-N>",
          prev = "<C-P>",
        },
      },
      filetypes = {
        ["*"] = true,
      },
    }))

    vim.keymap.set("i", "<C-A>", function()
      local s = require("copilot.suggestion")
      if s.is_visible() then
        s.accept()
      else
        s.next()
      end
    end, { silent = true })
  end,
}
