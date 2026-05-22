-- Leader keys must be set BEFORE any mapping uses <leader> or <localleader>,
-- including mappings defined by plugins. Anything we require below may define
-- such mappings, so these two lines must come first.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.plugins")
