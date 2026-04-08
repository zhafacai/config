vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("vim._core.ui2").enable({
	enable = true, -- Whether to enable or disable the UI.
})

require("opts")
require("keymaps")
require("ui")
require("mini")
require("tools")
require("dev")
require("zfc.dial")
require("zfc.blink")
require("zfc.org")
