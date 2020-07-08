local core = require "core"
local command = require "core.command"
local user = require "user"

local function base64enc(data)
  local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  return ((data:gsub('.', function(x)
    local r,b='',x:byte()
    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
    return r;
  end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if (#x < 6) then return '' end
    local c=0
    for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
    return b:sub(c+1,c+1)
  end)..({ '', '==', '=' })[#data%3+1])
end

local function base64dec(data)
  local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  data = string.gsub(data, '[^'..b..'=]', '')
  return (data:gsub('.', function(x)
    if (x == '=') then return '' end
    local r,f='',(b:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c)
  end))
end

local function capitalize(first,rest)
  return first:upper()..rest:lower()
end

local function manipulate(doc,opt,rex)
  if not doc:has_selection() then
    core.error("Cannot manupilate empty selection!.")
    return
  end
  local sline, scol, eline, ecol = doc:get_selection()
  local text = doc:get_text(sline, scol, eline, ecol)
  text = string.gsub(text,rex,opt)
  local tline, tcol = sline, scol
  if eline < sline then tline = eline end
  if ecol < scol then tcol = ecol end
  doc:remove(sline, scol, eline, ecol)
  doc:insert(tline, tcol, text)
  doc:set_selection(sline, scol, eline, ecol)
end

command.add("core.docview", {
  ["manipulator:upper"] = function()
    manipulate(core.active_view.doc,string.upper,".*")
  end,
  ["manipulator:lower"] = function()
    manipulate(core.active_view.doc,string.lower,".*")
  end,
  ["manipulator:tab2spaces"] = function()
    manipulate(core.active_view.doc,string.rep(" ",user.config.indent_size),"\t")
  end,
  ["manipulator:clean"] = function()
    manipulate(core.active_view.doc,"\n\n","[\r\n][\r\n]+")
  end,
  ["manipulator:capitalize"] = function()
    manipulate(core.active_view.doc,capitalize,"(%a)([%w_']*)")
  end,
  ["manipulator:base64enc"] = function()
    manipulate(core.active_view.doc,base64enc,".*")
  end,
  ["manipulator:base64dec"] = function()
    manipulate(core.active_view.doc,base64dec,".*")
  end,
})

