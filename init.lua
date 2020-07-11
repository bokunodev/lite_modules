local user = {}
-- put user settings here
-- this module will be loaded after everything else when the application starts

user.keymap = require "core.keymap"
user.config = require "core.config"
user.style = require "core.style"

-- key binding:
-- keymap.add { ["ctrl+escape"] = "core:quit" }
user.keymap.add { ["ctrl+q"] = "core:quit" }
user.keymap.add { ["alt+shift+s"] = "sort:sort" }

-- light theme:
-- require "user.colors.summer"
require "user.colors.nord"

user.config.fps = 30
user.config.ignore_files = "!"
user.config.max_undos = 100
user.config.highlight_current_line = true
user.config.line_height = 1.2
user.config.indent_size = 3
user.config.tab_type = "soft"
user.config.line_limit = 100

user.go_fmt_cmd = "goimports"
user.path_sep = "/"

return user

