return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>e",
      function()
        require("oil").open_float()
      end,
      desc = "Open parent directory (float)",
    },
    {
      "-",
      function()
        require("oil").open_float()
      end,
      desc = "Open parent directory (float)",
    },
  },
  opts = {
    default_file_explorer = true,
    view_options = { show_hidden = true },
    keymaps = {
      ["q"] = "actions.close",
      ["<esc>"] = "actions.close",
    },
    float = {
      padding = 2,
      max_width = 90,
      max_height = 30,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
  },
}
