local M = {}

local function run_system(cmd, cwd)
  if vim.system then
    local result = vim.system(cmd, { cwd = cwd, text = true }):wait()
    if result.code ~= 0 then
      return nil, vim.trim(result.stderr or "")
    end
    return vim.split(result.stdout or "", "\n", { trimempty = true })
  end

  local escaped = {}
  for _, part in ipairs(cmd) do
    table.insert(escaped, vim.fn.shellescape(part))
  end
  local prefix = ""
  if cwd and cwd ~= "" then
    prefix = "cd " .. vim.fn.fnameescape(cwd) .. " && "
  end
  local lines = vim.fn.systemlist(prefix .. table.concat(escaped, " "))
  if vim.v.shell_error ~= 0 then
    return nil, table.concat(lines, "\n")
  end
  return lines
end

local function strip_ansi(lines)
  local out = {}
  for _, line in ipairs(lines) do
    -- Strip CSI sequences like \x1b[...m
    line = line:gsub("\27%[[0-9;]*[A-Za-z]", "")
    table.insert(out, line)
  end
  return out
end

local function jj_root()
  local lines, err = run_system({ "jj", "root" })
  if not lines then
    return nil, err
  end
  local root = vim.trim(lines[1] or "")
  if root == "" then
    return nil, err
  end
  return root
end

local function status_symbol(status)
  if status == "A" then
    return "+"
  elseif status == "D" then
    return "-"
  elseif status == "M" then
    return "~"
  elseif status == "R" then
    return ">"
  end
  return "?"
end

local function parse_summary(lines)
  local files = {}
  for _, line in ipairs(lines) do
    local status, rest = line:match("^([A-Z?!])%s+(.+)$")
    if status and rest then
      local parts = vim.split(rest, "%s+")
      local path = parts[#parts]
      if path and path ~= "" then
        table.insert(files, {
          status = status,
          path = path,
          display = string.format("%s %s", status_symbol(status), path),
        })
      end
    end
  end
  return files
end

function M.diff_files()
  if vim.fn.executable("jj") ~= 1 then
    vim.notify("jj not found. Check your PATH.", vim.log.levels.ERROR)
    return nil
  end

  local root, err = jj_root()
  if not root then
    vim.notify("jj root を取得できません: " .. (err or ""), vim.log.levels.ERROR)
    return nil
  end

  local lines, diff_err = run_system({ "env", "NO_COLOR=1", "jj", "diff", "--summary", "-r", "@" }, root)
  if not lines then
    vim.notify("jj diff failed: " .. (diff_err or ""), vim.log.levels.ERROR)
    return nil
  end

  return root, parse_summary(strip_ansi(lines))
end

local function buf_set_lines(buf, lines)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

function M.pick_file()
  local root, files = M.diff_files()
  if not root then
    return
  end
  if #files == 0 then
    vim.notify("No changed files in the current change.", vim.log.levels.INFO)
    return
  end

  vim.ui.select(files, {
    prompt = "JJ diff files",
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if not choice or not choice.path then
      return
    end
    local full = root .. "/" .. choice.path
    if vim.fn.filereadable(full) == 1 then
      vim.cmd.edit(vim.fn.fnameescape(full))
    else
      vim.notify("File not found: " .. choice.path, vim.log.levels.WARN)
    end
  end)
end

function M.to_quickfix()
  local root, files = M.diff_files()
  if not root then
    return
  end

  local qf = {}
  for _, item in ipairs(files) do
    local full = root .. "/" .. item.path
    if vim.fn.filereadable(full) == 1 then
      table.insert(qf, { filename = full, lnum = 1, col = 1, text = item.display })
    end
  end

  if #qf == 0 then
    vim.notify("No diff files to open.", vim.log.levels.INFO)
    return
  end

  vim.fn.setqflist({}, " ", { title = "jj diff (@)", items = qf })
  vim.cmd("copen")
end

local function open_ui()
  local root, files = M.diff_files()
  if not root then
    return
  end
  if #files == 0 then
    vim.notify("No changed files in the current change.", vim.log.levels.INFO)
    return
  end

  vim.cmd("tabnew")
  local tab = vim.api.nvim_get_current_tabpage()

  local list_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[list_buf].buftype = "nofile"
  vim.bo[list_buf].bufhidden = "wipe"
  vim.bo[list_buf].swapfile = false
  vim.bo[list_buf].modifiable = false
  vim.bo[list_buf].filetype = "jjdiff"
  local list_lines = {}
  for _, item in ipairs(files) do
    table.insert(list_lines, item.display)
  end
  buf_set_lines(list_buf, list_lines)

  vim.api.nvim_set_current_buf(list_buf)
  local list_win = vim.api.nvim_get_current_win()
  vim.bo[list_buf].modifiable = false
  vim.bo[list_buf].readonly = true
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"

  vim.cmd("vsplit")
  local diff_win = vim.api.nvim_get_current_win()
  local total_w = vim.o.columns
  local list_w = math.max(20, math.floor(total_w * 0.25))
  if vim.api.nvim_win_is_valid(list_win) then
    vim.wo[list_win].winfixwidth = true
    vim.api.nvim_win_set_width(list_win, list_w)
  end
  if vim.api.nvim_win_is_valid(diff_win) then
    vim.wo[diff_win].winfixwidth = false
  end

  local diff_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[diff_buf].buftype = "nofile"
  vim.bo[diff_buf].bufhidden = "wipe"
  vim.bo[diff_buf].swapfile = false
  vim.bo[diff_buf].modifiable = false
  vim.bo[diff_buf].filetype = "diff"
  vim.api.nvim_set_current_buf(diff_buf)
  vim.api.nvim_set_current_win(diff_win)
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.signcolumn = "no"
  local diff_chan = vim.api.nvim_open_term(diff_buf, {})

  local function current_entry()
    local line = vim.api.nvim_get_current_line()
    local trimmed = vim.trim(line)
    local path = trimmed:sub(3)
    return {
      display = trimmed,
      path = vim.trim(path),
    }
  end

  local function update_diff()
    if not vim.api.nvim_buf_is_valid(list_buf) then
      return
    end
    if not vim.api.nvim_win_is_valid(diff_win) then
      return
    end
    if not vim.api.nvim_tabpage_is_valid(tab) then
      return
    end
    local entry = current_entry()
    if not entry.path or entry.path == "" then
      return
    end
    local lines, err = run_system({ "jj", "diff", "-r", "@", "--color", "always", entry.path }, root)
    if not lines then
      lines = { "jj diff failed: " .. (err or "") }
    end
    if #lines == 0 then
      lines = { "(no diff)" }
    end

    if not vim.api.nvim_buf_is_valid(diff_buf) then
      diff_buf = vim.api.nvim_create_buf(false, true)
      vim.bo[diff_buf].buftype = "nofile"
      vim.bo[diff_buf].bufhidden = "wipe"
      vim.bo[diff_buf].swapfile = false
      vim.bo[diff_buf].modifiable = false
      vim.bo[diff_buf].filetype = "diff"
      vim.api.nvim_win_set_buf(diff_win, diff_buf)
      diff_chan = vim.api.nvim_open_term(diff_buf, {})
    end
    if diff_chan then
      vim.api.nvim_chan_send(diff_chan, "\27[2J\27[H")
      vim.api.nvim_chan_send(diff_chan, table.concat(lines, "\n") .. "\n")
    end
  end

  local group = vim.api.nvim_create_augroup("JjDiffUI" .. list_buf, { clear = true })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = group,
    buffer = list_buf,
    callback = update_diff,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    buffer = list_buf,
    callback = function()
      if vim.api.nvim_buf_is_valid(diff_buf) then
        vim.api.nvim_buf_delete(diff_buf, { force = true })
      end
    end,
  })

  local function edit_file()
    local entry = current_entry()
    if not entry.path or entry.path == "" then
      return
    end
    if vim.api.nvim_tabpage_is_valid(tab) then
      vim.cmd("tabclose")
    end
    local full = root .. "/" .. entry.path
    if vim.fn.filereadable(full) == 1 then
      vim.cmd.edit(vim.fn.fnameescape(full))
    else
      vim.notify("File not found: " .. entry.path, vim.log.levels.WARN)
    end
  end

  local function close_ui()
    if vim.api.nvim_tabpage_is_valid(tab) then
      vim.cmd("tabclose")
    end
  end

  local opts = { buffer = list_buf, nowait = true, silent = true }
  vim.keymap.set("n", "e", edit_file, opts)
  vim.keymap.set("n", "<CR>", edit_file, opts)
  vim.keymap.set("n", "q", close_ui, opts)

  vim.api.nvim_set_current_win(list_win)
  update_diff()
end

function M.setup()
  vim.api.nvim_create_user_command("JjDiffUI", function()
    open_ui()
  end, { desc = "Open jj diff UI for current change (@)" })
end

return M
