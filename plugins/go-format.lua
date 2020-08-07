local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local user = require "user"

local error_msg = "ERROR %s:%s %s"
local fmt_cmd = user.go_fmt_cmd or "gofmt"

local function do_format(cmd,doc)
    local file = doc.get_name()
    if file == "unsaved" then
        core.error("Can't format unsaved document!.")
        return
    end
    if doc.is_dirty() then doc.save() end
    local p = io.popen(cmd.." -w "..file.." 2>&1")
    local out = p:read('*a')
    local status = {p:close()}
    local pl,pc,_,_ = doc:get_selection()
    if status[3] == 0 then
        doc:load(file)
        doc:set_selection(pl,pc)
        return
    elseif status[3] == 127 then
        core.error("Can't find "..cmd)
        return
    end
    local line,col,msg = out:match(':(%d-):(%d-):([^\n]+)')
    doc:set_selection(line,col)
    core.error(string.format(error_msg,line,col,msg))
end

command.add("core.docview", {
    ["go:format"] = function()
        do_format(fmt_cmd, core.active_view.doc)
    end,
})
