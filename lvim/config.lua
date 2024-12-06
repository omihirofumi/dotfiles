-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
lvim.colorscheme = "gruvbox-material"

vim.opt.shiftwidth = 4
vim.opt.tabstop = 2

-- clipboard
vim.opt.clipboard = ""
vim.keymap.set({ "v", "n" }, "y", '"+y')


-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["[b"] = ":bprev<cr>"
lvim.keys.normal_mode["]b"] = ":bnext<cr>"
lvim.keys.insert_mode["<C-b>"] = "<Left>"
lvim.keys.insert_mode["<C-f>"] = "<Right>"
lvim.keys.insert_mode["<C-e>"] = "<End>"
-- X closes a buffer
lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"

-- Centers cursor when moving 1/2 page down
lvim.keys.normal_mode["<C-d>"] = "<C-d>zz"

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "terraform", "tf" },
    command = "setlocal shiftwidth=2 tabstop=2",
})


-- terminal settings
-- function _G.set_terminal_keymaps()
--   local opts = { buffer = 0 }
--   vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
-- end
lvim.builtin.terminal.open_mapping = false

-- unbind default terminal shortcut
-- vim.keymap.del("t", "<C-h>")
-- vim.keymap.del("t", "<C-j>")
-- vim.keymap.del("t", "<C-k>")
-- vim.keymap.del("t", "<C-l>")
lvim.keys.term_mode["<C-h>"] = false
lvim.keys.term_mode["<C-l>"] = false

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- show files included .gitignore in tree
lvim.builtin.nvimtree.setup.filters.custom = {}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
require("lspconfig").pyright.setup {
    settings = {
        python = {
            venvPath = ".",
            pythonPath = "./.venv/bin/python",
            analysis = {
                extraPaths = { "." }
            }
        }
    }
}

-- サブディレクトリのファイルを開くとツリーが移動しないようにする
lvim.builtin.nvimtree.setup.update_focused_file.update_root = false
lvim.builtin.nvimtree.setup.sync_root_with_cwd = false

-- ターミナルのトグル
lvim.builtin.terminal.open_mapping = "<C-`>"


lvim.builtin.which_key.mappings["bs"] = { ":Chowcho<CR>", "Select buffer" }


lvim.plugins = {
    { "rebelot/kanagawa.nvim" },
    { "bakageddy/alduin.nvim", priority = 1000, config = true, opts = ... },
    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        config = function()
            -- Optionally configure and load the colorscheme
            -- directly inside the plugin declaration.
            vim.g.gruvbox_material_enable_italic = true
            vim.cmd.colorscheme('gruvbox-material')
        end
    },
    -- AI
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
                    auto_trigger = true,
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
    -- {
    --   "CopilotC-Nvim/CopilotChat.nvim",
    --   branch = "canary",
    --   dependencies = {
    --     { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    --     { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    --   },
    --   build = "make tiktoken",        -- Only on MacOS or Linux
    --   opts = {
    --     -- See Configuration section for options
    --   },
    --   -- See Commands section for default commands if you want to lazy load on them
    -- },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    { url = "https://github.com/vim-denops/denops.vim" },
    { url = "https://github.com/lambdalisue/kensaku.vim" },
    {
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
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        init = function()
            vim.g.mkdp_auto_close = 0
        end,
    },
    {
        "ixru/nvim-markdown"
    },
    {
        "tkmpypy/chowcho.nvim",
        config = function()
            require("chowcho").setup({
                -- Must be a single character. The length of the array is the maximum number of windows that can be moved.
                labels = { "A", "B", "C", "D", "E", "F", "G", "H", "I" },
                selector = "statusline", -- `float` or `statusline` (default: `float`)
                use_exclude_default = true,
                ignore_case = true,
                exclude = function(buf, win)
                    -- exclude noice.nvim's cmdline_popup
                    local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
                    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
                    if bt == "nofile" and (ft == "noice" or ft == "vim") then
                        return true
                    end
                    return false
                end,
                selector = {
                    float = {
                        border_style = "rounded",
                        icon_enabled = true,
                        color = {
                            label = {
                                active = "#c8cfff",
                                inactive = "#ababab",
                            },
                            text = {
                                active = "#fefefe",
                                inactive = "#d0d0d0",
                            },
                            border = {
                                active = "#b400c8",
                                inactive = "#fefefe",
                            },
                        },
                        zindex = 1,
                    },
                    statusline = {
                        color = {
                            label = {
                                active = "#fefefe",
                                inactive = "#d0d0d0",
                            },
                            background = {
                                active = "#3d7172",
                                inactive = "#203a3a",
                            },
                        },
                    },
                },
            })
        end,
    },
    {
        "vinnymeller/swagger-preview.nvim",
        cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
        build = "npm i",
        config = function()
            require("swagger-preview").setup({
                open_browser = {
                    enable = true,
                },
                port = 8003,
                host = "localhost"
            })
        end,
    },
}
