return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Oil" },

  keys = {
    {
      "<leader>e",
      function()
        if vim.bo.filetype ~= "oil" then
          vim.cmd("Oil --float")
        end
      end,
    },
    {
      "-",
      function()
        if vim.bo.filetype ~= "oil" then
          vim.cmd("Oil --float")
        end
      end,
    },
  },

  opts = {
    default_file_explorer = false,
    view_options = { show_hidden = true },

    preview_win = {
      update_on_cursor_moved = true,
    },

    keymaps = {
      ["q"] = "actions.close",
      ["<esc>"] = "actions.close",
      ["p"] = "actions.preview",
    },

    float = {
      padding = 2,
      max_width = 90,
      max_height = 30,
      border = "rounded",
      preview_split = "right",
    },
  },

  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        local arg = vim.fn.argv(0)
        if not arg or vim.fn.isdirectory(arg) ~= 1 then
          return
        end
        local dir = vim.fn.fnamemodify(arg, ":p")
        vim.schedule(function()
          vim.cmd.cd(dir)
          vim.cmd(("Oil %s"):format(vim.fn.fnameescape(dir)))
        end)
      end,
    })
  end,

  config = function(_, opts)
    require("oil").setup(opts)
  end,
}
