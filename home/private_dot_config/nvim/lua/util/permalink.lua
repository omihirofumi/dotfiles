local M = {}

-- プロジェクトルートからの相対パスでパーマリンクを生成
function M.copy_relative_permalink()
  -- プロジェクトルートを取得（git root優先、なければcwd）
  local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  if vim.v.shell_error ~= 0 then
    root = vim.fn.getcwd()
  end
  local filepath = vim.fn.expand("%:p")
  local relative_path = vim.fn.fnamemodify(filepath, ":s?" .. root .. "/??")
  if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
    -- ビジュアルモードの場合
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local link = relative_path .. ":" .. start_line .. "-" .. end_line
    vim.fn.setreg("+", link)
    print("Copied: " .. link)
  else
    -- ノーマルモードの場合
    local line = vim.fn.line(".")
    local link = relative_path .. ":" .. line
    vim.fn.setreg("+", link)
    print("Copied: " .. link)
  end
end

-- 相対パスを取得するヘルパー関数
local function get_relative_path()
  local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  if vim.v.shell_error ~= 0 then
    root = vim.fn.getcwd()
  end
  local filepath = vim.fn.expand("%:p")
  return vim.fn.fnamemodify(filepath, ":s?" .. root .. "/??")
end

-- GitHub関連の関数
function M.open_github()
  vim.fn.system("gh browse")
end

function M.open_github_file()
  local file_path = get_relative_path()
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local cmd = string.format("gh browse --branch %s %s", branch, file_path)
  vim.fn.system(cmd)
end

function M.open_github_line()
  local line_num = vim.fn.line(".")
  local file_path = get_relative_path()
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local cmd = string.format("gh browse --branch %s %s:%d", branch, file_path, line_num)
  vim.fn.system(cmd)
end

function M.open_github_range()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local file_path = get_relative_path()
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
  local cmd = string.format("gh browse --branch %s %s:%d-%d", branch, file_path, start_line, end_line)
  vim.fn.system(cmd)
end

return M
