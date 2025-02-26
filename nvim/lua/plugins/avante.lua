return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  opts = {
    -- add any opts here
    -- for example
    provider = "copilot",
    copilot = {
      model = "claude-3.7-sonnet",
    },
    auto_suggetions_provider = "copilot",
    file_selector = {
      provider = function(params)
        local filepaths = params.filepaths
        local title = params.title
        local handler = params.handler

        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        pickers
          .new({}, {
            prompt_title = title,
            finder = finders.new_table({
              results = filepaths,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
              actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection then
                  handler({ selection[1] })
                else
                  handler(nil)
                end
              end)
              return true
            end,
          })
          :find()
      end,

      provider_opts = {
        get_filepaths = function(params)
          local cwd = params.cwd
          local selected_filepaths = params.selected_filepaths

          -- fdコマンドで隠しファイル（--hidden）を含めて検索
          local cmd =
            string.format("fd --type f --base-directory '%s' --hidden --exclude .git", vim.fn.fnameescape(cwd))
          local output = vim.fn.system(cmd)
          local filepaths = vim.split(output, "\n", { trimempty = true })

          return vim
            .iter(filepaths)
            :filter(function(filepath)
              return not vim.tbl_contains(selected_filepaths, filepath)
            end)
            :totable()
        end,
      },
    },
    behaviour = {
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = true,
      minimize_diff = true,
    },
    windows = {
      position = "right",
      wrap = true,
      width = 30,
      sidebar_header = {
        enabled = true,
        align = "right",
        rounded = true,
      },
      input = {
        height = 5,
      },
      edit = {
        border = "single",
        start_insert = true,
      },
      ask = {
        floating = true,
        start_insert = true,
        border = "single",
      },
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
