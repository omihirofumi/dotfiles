return {
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  "neovim/nvim-lspconfig",
  dependencies = {
    "jose-elias-alvarez/typescript.nvim",
    init = function()
      local Snacks = require("snacks")
      Snacks.util.lsp.on({}, function(buffer, _)
        -- stylua: ignore
        vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
        vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
      end)
    end,
  },
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      -- tsserver will be automatically installed with mason and loaded with lspconfig
      tsserver = {},
      jdtls = {
        cmd_env = {
          JAVA_HOME = vim.fn.expand("$HOME/.local/share/mise/installs/java/oracle-21.0.2"),
          PATH = vim.fn.expand("$HOME/.local/share/mise/installs/java/oracle-21.0.2/bin:")
            .. vim.fn.expand("$HOME/.local/share/nvim/mason/bin:")
            .. (vim.env.PATH or ""),
        },
      },
      kotlin_lsp = {},
    },
    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    setup = {
      -- example to setup with typescript.nvim
      tsserver = function(_, opts)
        require("typescript").setup({ server = opts })
        return true
      end,
      kotlin_lsp = function(_, opts)
        local configs = require("lspconfig.configs")
        local lspconfig = require("lspconfig")

        if not configs.kotlin_lsp then
          configs.kotlin_lsp = {
            default_config = {
              cmd = { "kotlin-lsp" },
              filetypes = { "kotlin" },
              root_dir = lspconfig.util.root_pattern(
                "gradlew",
                ".git",
                "mvnw",
                "settings.gradle"
              ),
              single_file_support = true,
            },
          }
        end

        lspconfig.kotlin_lsp.setup(opts)
        return true
      end,
      -- Specify * to use this function as a fallback for any server
      -- ["*"] = function(server, opts) end,
    },
    inlay_hints = { enabled = false },
  },
}
