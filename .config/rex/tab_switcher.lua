local TERMINAL_CREATOR = "com.superlogical.terminal"
local SHELL_NAMES = {
  zsh = true,
  bash = true,
  fish = true,
  sh = true,
  dash = true,
  nu = true,
  pwsh = true,
}
local STATUS_PRIORITY = {
  blocked = 4,
  error = 3,
  working = 2,
  done = 1,
}
local MAX_PICK_ITEMS = 2000

local function single_line(s)
  if type(s) ~= "string" then
    return nil
  end
  local cleaned = s:gsub("[%c]+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  if cleaned == "" then
    return nil
  end
  return cleaned
end

local function basename(path)
  if type(path) ~= "string" or path == "" then
    return nil
  end
  if path == "/" or path == "~" then
    return path
  end
  local trimmed = path:gsub("/+$", "")
  if trimmed == "" then
    return "/"
  end
  return trimmed:match("([^/]+)$") or trimmed
end

local function shorten_home(path, home)
  if type(path) ~= "string" or path == "" then
    return nil
  end
  if type(home) ~= "string" or home == "" then
    return path
  end
  local norm_home = home:gsub("/+$", "")
  if norm_home == "" then
    return path
  end
  if path == norm_home then
    return "~"
  end
  local prefix = norm_home .. "/"
  if path:sub(1, #prefix) == prefix then
    return "~/" .. path:sub(#prefix + 1)
  end
  return path
end

local function is_default_window_label(label)
  if type(label) ~= "string" or label == "" then
    return true
  end
  return label:match("^Window %x+$") ~= nil
end

local function inspect_window_blocks(win)
  local first_block = nil
  local focused_block = nil
  local count = 0
  for _, layer in ipairs(win.layers or {}) do
    for _, block in ipairs(layer.blocks or {}) do
      count = count + 1
      if first_block == nil then
        first_block = block
      end
      if win.focused_block_id ~= nil and block.block_id == win.focused_block_id then
        focused_block = block
      end
    end
  end
  return focused_block or first_block, count
end

local function format_program_status(records)
  if type(records) ~= "table" then
    return nil
  end
  local best_rec = nil
  local best_prio = 0
  for _, rec in ipairs(records) do
    local prio = STATUS_PRIORITY[rec.state] or 0
    if prio > best_prio then
      best_prio = prio
      best_rec = rec
    end
  end
  if best_rec == nil then
    return nil
  end
  local detail = single_line(best_rec.msg) or single_line(best_rec.title)
  if detail ~= nil then
    return "[" .. best_rec.state .. ": " .. detail .. "]"
  end
  return "[" .. best_rec.state .. "]"
end

local function format_process(proc)
  if type(proc) ~= "table" then
    return nil, nil
  end
  local p = proc.foreground or proc.child
  local proc_name = nil
  if type(p) == "table" then
    if type(p.script) == "string" and p.script ~= "" then
      proc_name = single_line(basename(p.script))
    end
    if proc_name == nil then
      proc_name = single_line(p.name)
    end
  elseif type(proc.last_exit) == "table" and proc.last_exit.exit_code ~= nil then
    proc_name = string.format("exited (%d)", proc.last_exit.exit_code)
  end
  local raw_cwd = (type(p) == "table" and p.cwd)
    or (type(proc.child) == "table" and proc.child.cwd)
    or nil
  local cwd = single_line(shorten_home(raw_cwd, proc.home))
  return proc_name, cwd
end

local function join_parts(parts, sep)
  if #parts == 0 then
    return nil
  end
  return table.concat(parts, sep)
end

local function build_tab_item(session_id, session_label, win, idx, is_current)
  local block, pane_count = inspect_window_blocks(win)
  local proc_name = nil
  local cwd = nil
  local term_title = nil
  local status_tag = nil

  if block ~= nil and block.creator_name == TERMINAL_CREATOR then
    local proc = rex.call("com.superlogical.terminal.process", {
      session_id = session_id,
      block_id   = block.block_id,
      args       = {},
    })
    if proc ~= nil then
      proc_name, cwd = format_process(proc)
    end

    local title_res = rex.call("com.superlogical.terminal.title", {
      session_id = session_id,
      block_id   = block.block_id,
      args       = {},
    })
    if title_res ~= nil then
      term_title = single_line(title_res.title)
    end

    local status_res = rex.call("com.superlogical.terminal.program_status", {
      session_id = session_id,
      block_id   = block.block_id,
      args       = {},
    })
    if status_res ~= nil then
      status_tag = format_program_status(status_res.records)
    end
  end

  local used_term_title = false
  local tab_name = (not is_default_window_label(win.label)) and single_line(win.label) or nil

  if tab_name == nil and term_title ~= nil then
    tab_name = term_title
    used_term_title = true
  end

  if tab_name == nil and cwd ~= nil then
    local dir_name = basename(cwd)
    if dir_name ~= nil then
      if proc_name ~= nil and not SHELL_NAMES[proc_name] then
        tab_name = proc_name .. " (" .. dir_name .. ")"
      else
        tab_name = dir_name
      end
    end
  end

  if tab_name == nil then
    tab_name = proc_name
  end

  if tab_name == nil and block ~= nil then
    tab_name = single_line(block.label)
  end

  if tab_name == nil then
    tab_name = single_line(win.label) or ("Tab " .. tostring(idx))
  end

  local sub_parts = {}
  if status_tag ~= nil then
    sub_parts[#sub_parts + 1] = status_tag
  end
  if term_title ~= nil and not used_term_title and term_title ~= tab_name then
    sub_parts[#sub_parts + 1] = term_title
  end
  if proc_name ~= nil then
    sub_parts[#sub_parts + 1] = proc_name
  end
  if cwd ~= nil then
    sub_parts[#sub_parts + 1] = cwd
  end
  local subtitle = join_parts(sub_parts, " · ")

  local detail_parts = {}
  if pane_count > 1 then
    detail_parts[#detail_parts + 1] = tostring(pane_count) .. " panes"
  end
  if is_current then
    detail_parts[#detail_parts + 1] = "current"
  end
  local detail = join_parts(detail_parts, " · ")

  local item = {
    id    = session_id .. "::" .. win.window_id,
    title = string.format("%s / %d: %s", session_label, idx, tab_name),
    icon  = is_current and "star" or "terminal",
  }
  if subtitle ~= nil then
    item.subtitle = subtitle
  end
  if detail ~= nil then
    item.detail = detail
  end
  return item
end

local function build_items(ctx)
  local list, list_err = rex.call("session.list")
  if list == nil then
    error(list_err or "failed to list sessions", 0)
  end

  local items = {}
  local targets = {}

  for _, sess in ipairs(list.sessions or {}) do
    if #items >= MAX_PICK_ITEMS then
      break
    end
    local view, view_err = rex.call("session.view", { session_id = sess.session_id })
    if view == nil then
      rex.log("warn", "switch_tab: session.view failed for " .. tostring(sess.session_id) .. ": " .. tostring(view_err))
    else
      local session_label = single_line(view.label) or single_line(sess.label) or sess.session_id
      for idx, win in ipairs(view.windows or {}) do
        if #items >= MAX_PICK_ITEMS then
          break
        end
        if win.window_id ~= nil then
          local is_current = (ctx ~= nil and sess.session_id == ctx.session_id and win.window_id == view.active_window_id)
          local item = build_tab_item(sess.session_id, session_label, win, idx, is_current)
          items[#items + 1] = item
          targets[item.id] = {
            session_id = sess.session_id,
            window_id  = win.window_id,
          }
        end
      end
    end
  end

  return items, targets
end

rex.action{
  name        = "switch_tab",
  title       = "Switch Tab…",
  description = "Pick a tab across all sessions and jump to it.",
  category    = "Tab",
  keywords    = "tab window session switch jump go picker",
  run         = function(ctx, args)
    local items, targets = build_items(ctx)
    if #items == 0 then return end

    local chosen, why, detail = rex.ui.pick{
      title       = "Switch Tab",
      placeholder = "Filter by session, tab, process, or directory",
      items       = items,
    }
    if chosen == nil then
      if why == "cancelled" or why == "timeout" then return end
      rex.log("warn", "switch_tab: " .. tostring(why) .. (detail and (" " .. detail) or ""))
      return
    end

    local target = targets[chosen]
    if target == nil then return end

    local _, focus_err = rex.call("session.focus_window", {
      session_id = target.session_id,
      window_id  = target.window_id,
    })
    if focus_err ~= nil then
      error(focus_err, 0)
    end

    if ctx.client_id ~= nil then
      local ok, qerr = pcall(rex.client.queue, "session.select", {
        session_id = target.session_id,
        window_id  = target.window_id,
      })
      if not ok then
        rex.log("warn", "switch_tab: session.select failed: " .. tostring(qerr))
      end
    end
  end,
}

return {
  build_items = build_items,
}
