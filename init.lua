-- put user settings here
-- this module will be loaded after everything else when the application starts

local keymap = require "core.keymap"
local config = require "core.config"
local style = require "core.style"

-- key binding:
-- keymap.add { ["ctrl+escape"] = "core:quit" }
keymap.add { ["ctrl+q"] = "core:quit" }
keymap.add { ["alt+shift+s"] = "sort:sort" }

-- light theme:
-- require "user.colors.summer"
require "user.colors.nord"

config.fps = 30
config.ignore_files = "!"
config.max_undos = 1000
config.highlight_current_line = true
config.line_height = 1.2
config.indent_size = 2
config.tab_type = "soft"
config.line_limit = 100

