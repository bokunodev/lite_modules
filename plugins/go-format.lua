local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"

local user = require "user"

local format_command = user.go_format_command or "gofmt"
local error_msg = "ERROR line:%d col:%d %s"
local function do_format(cmd,doc)
  local file = doc.filename
  local p = io.popen(format_command..' -w '..file..' 2>&1')
  local out = p:read('*a')
  local status = {p:close()}
  if status[3] == 0 then
    doc:load(file)
    return
  elseif status[3] == 127 then
    core.error("exit code 127\n"..format_command..": command not found!\nMake sure you have "..format_command.." installed in your $PATH.")
    return
  end
  core.error(string.format(error_msg,out:match(':(%d-):(%d-):([^\n]+)')))
end

command.add("core.docview", {
  ["go:format"] = function()
    do_format(format_command, core.active_view.doc)
  end,
})

