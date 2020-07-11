local core = require "core"
local command = require "core.command"
local user = require "user"

local PATHSEP = user.path_sep or "/"

local function action(doc,patt)
  if not doc.filename then
    core.error("Cannot copy location of unsaved doc")
    return
  end
  local filename = system.absolute_path(doc.filename)
  filename = string.gsub(filename,patt,"")
  core.log("Copying to clipboard \"%s\"", filename)
  system.set_clipboard(filename)
end

command.add("core.docview", {
  ["copy:file name"] = function()
    action(core.active_view.doc,string.format(".*%s",PATHSEP))
  end,
  ["copy:path to file"] = function()
    action(core.active_view.doc,string.format("[^%s]+$",PATHSEP))
  end,
  ["copy:file location"] = function()
    action(core.active_view.doc,"")
  end,
})

