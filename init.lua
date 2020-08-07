local user = {}

user.keymap = require("core.keymap")
user.config = require("core.config")
user.style  = require("core.style")

require("user.colors.summer")

user.config.fps = 30
user.config.ignore_files = nil
user.config.max_undos = 100
user.config.highlight_current_line = true
user.config.line_height = 1.2
user.config.indent_size = 4
user.config.tab_type = "soft"
user.config.line_limit = 100

user.go_fmt_cmd = "goimports"

user.keymap.add({
    ["ctrl+q"] = "core:quit",
    ["alt+shift+s"] = "sort:sort",
})

return user
