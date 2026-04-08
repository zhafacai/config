vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.pack.add({
	"https://github.com/Olical/nfnl",
})
vim.loader.enable() -- (optional) before the `bootstrap`s above, it could increase startuptime.

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
