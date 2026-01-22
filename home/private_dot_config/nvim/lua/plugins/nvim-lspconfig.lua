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
  opts = function(_, opts)
    local util = require("lspconfig.util")
    local configs = require("lspconfig.configs")

    ---@type lspconfig.options
    opts.servers = opts.servers or {}
    -- tsserver will be automatically installed with mason and loaded with lspconfig
    opts.servers.tsserver = opts.servers.tsserver or {}

    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    opts.setup = opts.setup or {}
    -- example to setup with typescript.nvim
    opts.setup.tsserver = function(_, server_opts)
      require("typescript").setup({ server = server_opts })
      return true
    end

    opts.inlay_hints = { enabled = false }

    return opts
  end,
}
