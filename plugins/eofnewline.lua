local core = require "core"
local command = require "core.command"
local Doc = require "core.doc"

local function eof_newline(doc)
  local leof,neof = #doc.lines,#doc.lines
  for i = leof,1,-1 do
    if not string.match(doc.lines[i],"^%s*$") then
      break
    end
    neof = i
  end
  doc:remove(neof,math.huge,leof,math.huge)
  if doc.lines[neof] ~= "\n" then
    doc:insert(neof,math.huge,"\n")
  end
end

command.add("core.docview", {
  ["eof-newline:eof-newline"] = function()
    eof_newline(core.active_view.doc)
  end,
})

local save = Doc.save
Doc.save = function(self, ...)
  eof_newline(self)
  save(self, ...)
end

