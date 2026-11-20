local terminal = "com.superlogical.terminal"
local shell = terminal .. ".shell"

local function read_selection()
  local r, err = rex.exec({ "pbpaste" }, { timeout = 5, env = { LANG = "en_US.UTF-8" } })
  if r == nil then error(err, 0) end
  local text = r.stdout:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" then error("The clipboard is empty. Copy the selection first.", 0) end
  return text
end

local function preview(text, limit)
  local flat = text:gsub("%s+", " ")
  if #flat <= limit then return flat end
  local cut = limit
  while cut > 0 do
    local b = flat:byte(cut + 1)
    if b == nil or b < 0x80 or b > 0xBF then break end
    cut = cut - 1
  end
  return flat:sub(1, cut) .. "…"
end

local function quote(text)
  local lines = {}
  for line in (text .. "\n"):gmatch("(.-)\r?\n") do
    table.insert(lines, line == "" and ">" or "> " .. line)
  end
  return table.concat(lines, "\n")
end

local function read_json(path)
  local f = io.open(path, "r")
  if f == nil then return nil end
  local body = f:read("*a")
  f:close()
  local ok, decoded = pcall(rex.json.decode, body)
  if ok then return decoded end
end

local agents = {
  claude = function(fg, prompt)
    local session = read_json(os.getenv("HOME") .. "/.claude/sessions/" .. fg.pid .. ".json")
    if session ~= nil and session.sessionId ~= nil then
      return { "claude", "--resume", session.sessionId, "--fork-session", prompt }
    end
    return { "claude", "--continue", "--fork-session", prompt }
  end,
  codex = function(fg, prompt)
    return { "codex", "fork", "--last", prompt }
  end,
}

local function foreground_agent()
  local info, err = rex.block.call(terminal, "process", {})
  if info == nil then error(err, 0) end
  local fg = info.foreground
  local label = fg and (fg.script or fg.argv0 or fg.name)
  local name = label and label:match("([^/]+)$")
  if name == nil or agents[name] == nil then
    error("The focused pane isn't running claude or codex (found " .. tostring(name) .. ").", 0)
  end
  return fg, agents[name]
end

local function reply(text)
  local data = "\27[200~" .. quote(text) .. "\n\n\27[201~"
  local _, err = rex.block.call(terminal, "write", { data = data })
  if err ~= nil then error(err, 0) end
end

local function side_chat(ctx, fg, fork_command, text)
  local question = rex.ui.input{
    title = "Side chat about: " .. preview(text, 60),
    placeholder = "Question",
    confirm = "Start side chat",
  }
  if question == nil or question:match("^%s*$") then return end

  local prompt = quote(text) .. "\n\n" .. question
  local created, err = rex.session.new_split{
    anchor_id = ctx.block_id,
    direction = "horizontal",
    side = "after",
    focus = true,
    layout = rex.layout.block{
      flavor = shell,
      label = "side chat",
      options = {
        command = fork_command(fg, prompt),
        cwd = fg.cwd,
        interactive = true,
      },
    },
  }
  if err ~= nil then error(err, 0) end
  return created
end

rex.action{
  name = "agent_selection",
  title = "Ask Agent About Selection…",
  description = "Quote the copied selection into the focused claude or codex pane, or fork the conversation into a side chat about it.",
  category = "Agents",
  keywords = "claude codex reply quote side chat fork selection",
  args = { mode = "string?" },
  run = function(ctx, args)
    local fg, fork_command = foreground_agent()
    local text = read_selection()

    local mode = args.mode
    if mode == nil then
      mode = rex.ui.pick{
        title = "“" .. preview(text, 60) .. "”",
        items = {
          { id = "reply", title = "Reply", subtitle = "Quote it into this conversation's input", icon = "link" },
          { id = "side_chat", title = "Start side chat", subtitle = "Fork this conversation into a new pane", icon = "plus" },
        },
      }
      if mode == nil then return end
    end

    if mode == "reply" then
      reply(text)
    elseif mode == "side_chat" then
      return side_chat(ctx, fg, fork_command, text)
    else
      error("Unknown mode " .. tostring(mode) .. "; use reply or side_chat.", 0)
    end
  end,
}
