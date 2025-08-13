-- ~/.config/nvim/lua/plugins/pr-review.lua
return {
  -- === GitHub PR 操作（Octo.nvim） ==========================================
  {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enable_builtin = true,
      suppress_missing_scope = { projects_v2 = true },
    },
    keys = {
      -- PR 一覧/チェックアウト
      { "<leader>gpl", ":Octo pr list<CR>", desc = "PR: List" },
      { "<leader>gpc", ":Octo pr checkout ", desc = "PR: Checkout (input #)", silent = false },

      -- レビュー開始/提出/状態操作
      { "<leader>gpr", ":Octo review start<CR>", desc = "PR: Review Start" },
      { "<leader>grs", ":Octo review submit ", desc = "PR: Review Submit", silent = false },
      { "<leader>grx", ":Octo review close<CR>", desc = "PR: Review Close" },
      { "<leader>grr", ":Octo review resume<CR>", desc = "PR: Review Resume" },
      { "<leader>grd", ":Octo review discard<CR>", desc = "PR: Review Discard" },

      -- チェックス
      { "<leader>gpa", ":Octo pr checks<CR>", desc = "PR: Checks" },
    },
  },

  -- === 差分ビュー（Diffview.nvim） ==========================================
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gpd", "<cmd>DiffviewOpen<CR>", desc = "Diffview: Open (working tree)" },
      { "<leader>gpx", "<cmd>DiffviewClose<CR>", desc = "Diffview: Close" },
      { "<leader>gpf", "<cmd>DiffviewToggleFiles<CR>", desc = "Diffview: Toggle Files Panel" },
      { "<leader>gpp", "<cmd>DiffviewFocusFiles<CR>", desc = "Diffview: Focus Files Panel" },
      { "<leader>gph", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview: File History (current file)" },
      { "<leader>gpo", "<cmd>PRDiff<CR>", desc = "Diffview: Open base...HEAD (from gh)" },
      { "<leader>gpn", "]q", desc = "Diffview: Next file" },
      { "<leader>gpN", "[q", desc = "Diffview: Prev file" },
      { "<leader>gob", "<cmd>tabnext<CR>", desc = "Back to Diffview tab" },
    },
    opts = function()
      local actions = require("diffview.actions")
      return {
        keymaps = {
          view = {
            ["<leader>e"] = false,
            ["<leader>b"] = false,
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle Files Panel" } },
            { "n", "<leader>b", actions.focus_files, { desc = "Focus Files Panel" } },
          },
          file_panel = {
            ["<leader>e"] = false,
            ["<leader>b"] = false,
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle Files Panel" } },
            { "n", "<leader>b", actions.focus_files, { desc = "Focus Files Panel" } },
          },
          file_history_panel = {
            ["<leader>e"] = false,
            ["<leader>b"] = false,
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle Files Panel" } },
            { "n", "<leader>b", actions.focus_files, { desc = "Focus Files Panel" } },
          },
        },
      }
    end,
    config = function(_, opts)
      require("diffview").setup(opts)
      local function run(cmd)
        if vim.system then
          local res = vim.system(cmd, { text = true }):wait()
          return res.code == 0 and vim.trim(res.stdout) or nil
        else
          local out = vim.fn.system(cmd)
          return vim.v.shell_error == 0 and vim.trim(out) or nil
        end
      end

      local function diff_pr_base()
        run({ "git", "fetch", "--all", "--prune" })
        local base = run({ "gh", "pr", "view", "--json", "baseRefName", "-q", ".baseRefName" })
        if not base or base == "" then
          vim.notify(
            "PR の base を取得できません。PRブランチ上か、`gh auth login` を確認してください。",
            vim.log.levels.ERROR
          )
          return
        end
        local head = run({ "git", "rev-parse", "--abbrev-ref", "HEAD" }) or "HEAD"
        local remote
        for _, r in ipairs({ "origin", "upstream" }) do
          if run({ "git", "rev-parse", r .. "/" .. base }) then
            remote = r
            break
          end
        end
        if not remote then
          vim.notify(
            "リモートに " .. base .. " が見つかりません。`git fetch --all` を実行してください。",
            vim.log.levels.ERROR
          )
          return
        end
        vim.cmd("DiffviewOpen " .. remote .. "/" .. base .. "..." .. head)
      end

      vim.api.nvim_create_user_command("PRDiff", diff_pr_base, { desc = "Open PR base...HEAD in Diffview" })
    end,
  },

  -- === 行単位の差分/ステージ（Gitsigns） ===================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {}, -- 必要なら追記
  },
}
