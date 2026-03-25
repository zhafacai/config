vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.pack.add({
	"https://git.sr.ht/~technomancy/fennel",
	"https://github.com/aileot/nvim-thyme",
	"https://github.com/eraserhd/parinfer-rust",
})
-- Wrapping the `require` in `function-end` is important for lazy-load.
table.insert(package.loaders, function(...)
	return require("thyme").loader(...) -- Make sure to `return` the result!
end)
-- NOTE: Add a cache path to &rtp. The path MUST include the literal substring "/thyme/compile".
local thyme_cache_prefix = vim.fn.stdpath("cache") .. "/thyme/compiled"
vim.opt.rtp:prepend(thyme_cache_prefix)
-- NOTE: `vim.loader` internally cache &rtp, and recache it if modified.
-- Please test the best place to `vim.loader.enable()` by yourself.
vim.loader.enable() -- (optional) before the `bootstrap`s above, it could increase startuptime.
-- In init.lua,
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function() -- You can substitute vim.schedule_wrap if you don't mind its tiny overhead.
		vim.schedule(function()
			require("thyme").setup()
		end)
	end,
})

require("opts")
require("keymaps")
require("ui")
require("mini")
require("tools")
require("dev")
require("dial")
require("blink")
