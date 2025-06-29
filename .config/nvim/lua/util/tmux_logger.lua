local M = {}

local logger_pane_title = "devshell"

local function find_pane_by_title(title)
  local handle =
      io.popen("tmux list-panes -a -F '#{pane_id} #{pane_title}' | grep ' " .. title .. "$' | awk '{print $1}'")
  if not handle then
    return nil
  end
  local pane_id = handle:read("*a"):gsub("%s+", "")
  handle:close()
  if pane_id == "" then
    return nil
  end
  return pane_id
end

local function get_caller_module_name()
  local info = debug.getinfo(3, "S") -- 3: setup -> caller -> source
  if info and info.source then
    local path = info.source:gsub("^@", "")
    local name = path:match("([^/\\]+)%.lua$")
    return name or "unknown"
  end
  return "unknown"
end

function M.setup()
  local name = get_caller_module_name()
  local tmux_target = find_pane_by_title(logger_pane_title)

  if not tmux_target then
    vim.notify("tmux_logger: No tmux pane found with title '" .. logger_pane_title .. "'", vim.log.levels.ERROR)
  else
    vim.notify("tmux_logger: Logging target set to tmux pane " .. tmux_target, vim.log.levels.INFO)
  end

  local warned_no_target = false

  local function logger(msg)
    if not tmux_target then
      if not warned_no_target then
        warned_no_target = true
        vim.notify("tmux_logger: No tmux target set; logging disabled.", vim.log.levels.WARN)
      end
      return
    end

    msg = type(msg) == "string" and msg or vim.inspect(msg)
    local prefix = "[" .. name .. "] "
    local escaped_msg = msg:gsub("'", "'\\''")
    local full_msg = prefix .. escaped_msg
    local cmd = string.format("tmux send-keys -t %s \"echo '%s'\" C-m", tmux_target, full_msg)
    os.execute(cmd)
  end

  return logger
end

return M
