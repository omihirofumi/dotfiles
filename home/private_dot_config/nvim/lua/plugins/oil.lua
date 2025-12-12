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
      -- === 既存キーマップ ===
      ["q"] = "actions.close",
      ["<esc>"] = "actions.close",

      ["yp"] = {
        desc = "Yank absolute path of file under cursor",
        callback = function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()

          if not entry then
            print("No entry under cursor")
            return
          end

          if not dir then
            print("Current dir is unknown (not a local adapter?)")
            return
          end

          -- パス結合は joinpath を使うと安全
          local fullpath = vim.fs.normalize(vim.fs.joinpath(dir, entry.name))

          -- デフォルトレジスタと + 両方に入れる
          vim.fn.setreg(vim.v.register, fullpath)
          vim.fn.setreg("+", fullpath)

          print("Yanked: " .. fullpath)
        end,
      },
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
