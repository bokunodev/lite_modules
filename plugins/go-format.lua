local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"

local user = require "user"
local error_msg = "ERROR line:%s col:%s %s"

local fmt_cmd = user.go_fmt_cmd or "gofmt"

local function do_format(cmd,doc)
  local file = doc.filename
  local p = io.popen(cmd.." -w "..file.." 2>&1")
  local out = p:read('*a')
  local status = {p:close()}
  if status[3] == 0 then
    doc:load(file)
    return
  elseif status[3] == 127 then
    core.error("Command '"..cmd.."' not found in the system")
    return
  end
  local line,col,msg = out:match(':(%d-):(%d-):([^\n]+)')
  core.error(string.format(error_msg,line,col,msg))
end

command.add("core.docview", {
  ["go:format"] = function()
    do_format(fmt_cmd, core.active_view.doc)
  end,
})

