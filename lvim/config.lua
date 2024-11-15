-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
lvim.colorscheme = "kanagawa"

-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["[b"] = ":bprev<cr>"
lvim.keys.normal_mode["]b"] = ":bnext<cr>"
lvim.keys.insert_mode["<C-b>"] = "<Left>"
lvim.keys.insert_mode["<C-f>"] = "<Right>"
lvim.keys.insert_mode["<C-e>"] = "<End>"
lvim.keys.insert_mode["<C-a>"] = "<Home>"

--which-key
lvim.builtin.which_key.mappings["i"] = {
  ":CopilotChatOpen<CR>", "Copilot Chat"
}

-- terminal settings
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
end

-- unbind default terminal shortcut
-- vim.keymap.del("t", "<C-h>")
-- vim.keymap.del("t", "<C-j>")
-- vim.keymap.del("t", "<C-k>")
-- vim.keymap.del("t", "<C-l>")
lvim.keys.term_mode["<C-h>"] = false
lvim.keys.term_mode["<C-l>"] = false

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- show files included .gitignore in tree
lvim.builtin.nvimtree.setup.filters.custom = {}

lvim.plugins = {
  { "rebelot/kanagawa.nvim" },
  { "bakageddy/alduin.nvim", priority = 1000 , config = true, opts = ...},
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup({
        suggestion = { enabled = false },
        panel = { enabled = false }
      })
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  }
}
