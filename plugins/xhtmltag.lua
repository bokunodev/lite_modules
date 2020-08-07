local translate = require "core.doc.translate"
local command = require "core.command"
local keymap = require "core.keymap"
local core = require "core"

local function close_tag(doc,patt,inline)
    local pos = {doc:get_selection(true)}
    local s = {translate.start_of_word(doc,pos[1],pos[2])}
    local str = doc:get_text(s[1],s[2],pos[1],pos[2])
    doc:remove(s[1],s[2],pos[1],pos[2])
    if inline then
        doc:insert(s[1],s[2],string.format(patt,str))
        doc:set_selection(pos[1],pos[2]+3)
        return
    end
    doc:insert(s[1],s[2],string.format(patt,str,str))
    doc:set_selection(pos[1],pos[2]+2)
end

command.add("core.docview", {
    ["xml:closetag"] = function()
        close_tag(core.active_view.doc,"<%s></%s>")
    end,
    ["xml:closetaginline"] = function()
        close_tag(core.active_view.doc,"<%s/>",true)
    end,
})

keymap.add {
    ["alt+shift+,"] = "xml:closetag",
    ["alt+shift+."] = "xml:closetaginline",
}
