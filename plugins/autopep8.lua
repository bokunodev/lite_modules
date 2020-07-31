local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"

local user = require("user")

local error_msg = "ERROR line:%s co:%s %s"

local autopep8_flag = user.autopep8_flag or "-i -j 4 -a --experimental --ignore E501"
local pycodestyle_flag = user.pycodestyle_flag or "--ignore E501"

local fmt_cmd = "%s %s %s 2>&1"

local function do_format(cmd,flag,doc)
  local file = doc.filename
  local p = io.popen(string.format(fmt_cmd, cmd,flag,file))
  local out = p:read('*a')
  local status = {p:close()}
  local pl,pc,_,_ = doc:get_selection()
  if status[3] == 0 then
    doc:load(file)
    doc:set_selection(pl,pc)
    return
  elseif status[3] == 127 then
    core.error("Command '"..cmd.."' not found in the system")
    return
  end
  local line,col,msg = out:match(':(%d-):(%d-):%s+%w+%s+([^\n]+)')
  doc:set_selection(line,col)
  core.error(string.format(error_msg,line,col,msg))
end

command.add("core.docview", {
  ["python:check"] = function()
    do_format("pycodestyle",pycodestyle_flag,core.active_view.doc)
  end,
  ["python:format"] = function()
    do_format("autopep8",autopep8_flag,core.active_view.doc)
  end,
})
