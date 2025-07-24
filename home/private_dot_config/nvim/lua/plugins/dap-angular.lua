return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mxsdev/nvim-dap-vscode-js",
    {
      "microsoft/vscode-js-debug",
      version = "1.x",
      build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
  },

  -- カスタムキーマップを追加
  keys = {
    {
      "<leader>dq",
      function()
        require("dap").terminate()
      end,
      desc = "Terminate Debug Session",
    },
    {
      "<leader>dQ",
      function()
        require("dap").close()
      end,
      desc = "Close Debug Session",
    },
    {
      "<leader>dx",
      function()
        require("dap").terminate()
        require("dapui").close()
      end,
      desc = "Stop Debug & Close UI",
    },
  },

  opts = function()
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome" },
    })

    local dap = require("dap")

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
      if not dap.configurations[language] then
        dap.configurations[language] = {}
      end

      vim.list_extend(dap.configurations[language], {
        -- Angular開発サーバー（ポート8082）- ダイアログ回避版
        {
          type = "pwa-chrome",
          request = "launch",
          name = "🅰️ Launch Angular (8082)",
          url = "http://localhost:8082",
          webRoot = "${workspaceFolder}",
          userDataDir = "${workspaceFolder}/.chrome-debug-profile",
          sourceMaps = true,
          runtimeArgs = {
            "--no-first-run",
            "--no-default-browser-check",
            "--disable-extensions",
            "--disable-plugins",
            "--disable-web-security",
            "--disable-features=TranslateUI",
          },
        },

        -- Angular開発サーバー（ポート4200）
        {
          type = "pwa-chrome",
          request = "launch",
          name = "🅰️ Launch Angular (4200)",
          url = "http://localhost:4200",
          webRoot = "${workspaceFolder}",
          userDataDir = "${workspaceFolder}/.chrome-debug-profile",
          sourceMaps = true,
          runtimeArgs = {
            "--no-first-run",
            "--no-default-browser-check",
            "--disable-extensions",
          },
        },

        -- 既に動いているChromeにアタッチ
        {
          type = "pwa-chrome",
          request = "attach",
          name = "🔗 Attach to Chrome (9222)",
          port = 9222,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },

        -- Node.js単体ファイルのデバッグ
        {
          type = "pwa-node",
          request = "launch",
          name = "🟢 Launch current file (Node)",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**" },
        },
      })
    end
  end,
}
