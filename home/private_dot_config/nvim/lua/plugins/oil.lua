return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    local group = vim.api.nvim_create_augroup("oil_start_dir", { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function()
        if vim.fn.argc() ~= 1 then
          return
        end
        local arg = vim.fn.argv(0)
        if arg and vim.fn.isdirectory(arg) == 1 then
          vim.cmd.cd(arg)
          require("oil").open(arg, { preview = {} })
        end
      end,
    })
  end,
  keys = {
    {
      "<leader>e",
      function()
        require("oil").open_float(nil, { preview = {} })
      end,
      desc = "Open parent directory (float)",
    },
    {
      "-",
      function()
        require("oil").open_float(nil, { preview = {} })
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
    preview_win = {
      update_on_cursor_moved = true,
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
