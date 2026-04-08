-- [nfnl] fnl/dev.fnl
do
	vim.pack.add({ { src = "https://github.com/rafamadriz/friendly-snippets" } })
end
do
	vim.pack.add({ { src = "https://github.com/chrisgrieser/nvim-scissors" } })
end
do
	local scissors = require("scissors")
	local function _1_()
		return scissors.editSnippet()
	end
	vim.keymap.set("n", "<leader>se", _1_, { desc = "Snippet: Edit" })
	local function _2_()
		return scissors.addNewSnippet()
	end
	vim.keymap.set({ "n", "x" }, "<leader>sa", _2_, { desc = "Snippet: Add" })
end
do
	vim.pack.add({ { src = "https://github.com/mikavilpas/blink-ripgrep.nvim" } })
end
do
	vim.pack.add({ { src = "https://github.com/moyiz/blink-emoji.nvim" } })
end
do
	vim.pack.add({ { src = "https://github.com/xzbdmw/colorful-menu.nvim" } })
end
do
	vim.pack.add({ { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*") } })
end
do
	vim.pack.add({ { src = "https://github.com/neovim/nvim-lspconfig" } })
end
do
	local ser = { "tsgo", "lua_ls", "ty", "zls", "clangd", "tailwindcss", "nixd", "jsonls", "org" }
	vim.lsp.enable(ser)
end
do
	vim.pack.add({ { src = "https://github.com/mfussenegger/nvim-lint" } })
end
do
	local lint = require("lint")
	local linters = { python = { "ruff" }, markdown = { "rumdl" } }
	local function _3_()
		return lint.try_lint()
	end
	vim.api.nvim_create_autocmd("BufWritePost", { callback = _3_, pattern = "*" })
	lint["linters_by_ft"] = linters
end
do
	vim.pack.add({ { src = "https://github.com/folke/lazydev.nvim" } })
	require("lazydev").setup({ library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } })
end
do
	vim.pack.add({ { src = "https://github.com/rachartier/tiny-code-action.nvim" } })
	require("tiny-code-action").setup({
		backend = "vim",
		picker = { "buffer", opts = { auto_preview = true, hotkeys = true, hotkeys_mode = "text_based" } },
	})
end
do
	vim.pack.add({ { src = "https://github.com/chrisgrieser/nvim-spider" } })
end
do
	local spider_motion
	local function _4_(_241)
		local m = _241
		return ("<cmd>lua require('spider').motion('" .. m .. "')<CR>")
	end
	spider_motion = _4_
	vim.keymap.set({ "n", "o", "x" }, "w", spider_motion("w"), { desc = "Spider: w" })
	vim.keymap.set({ "n", "o", "x" }, "e", spider_motion("e"), { desc = "Spider: e" })
	vim.keymap.set({ "n", "o", "x" }, "b", spider_motion("b"), { desc = "Spider: b" })
	vim.keymap.set({ "n", "o", "x" }, "ge", spider_motion("ge"), { desc = "Spider: ge" })
end
do
	vim.pack.add({ { src = "https://github.com/farmergreg/vim-lastplace" } })
end
do
	vim.pack.add({ { src = "https://github.com/max397574/better-escape.nvim" } })
	require("better_escape").setup({ mappings = { t = { j = { k = false } } } })
end
do
	vim.pack.add({ { src = "https://github.com/folke/flash.nvim" } })
	require("flash").setup({ label = { uppercase = false } })
end
do
	local flash = require("flash")
	local function _5_()
		return flash.jump()
	end
	vim.keymap.set({ "n", "x", "o" }, "<c-s>", _5_, { desc = "Flash jump" })
	local function _6_()
		return flash.treesitter()
	end
	vim.keymap.set("n", "S", _6_, { desc = "Flash treesitter" })
	local function _7_()
		return flash.toggle()
	end
	vim.keymap.set("c", "<c-s>", _7_, { desc = "Flash toggle" })
end
do
	vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter" } })
end
do
	local ts_fts = { "typescript", "lua", "html", "yaml", "comment", "fennel", "bpftrace", "cpp", "nix", "python" }
	local nts = require("nvim-treesitter")
	nts.install(ts_fts)
	local function _8_()
		vim.treesitter.start()
		vim.opt["indentexpr"] = "v:lua.require'nvim-treesitter'.indentexpr()"
		return nil
	end
	vim.api.nvim_create_autocmd("FileType", { callback = _8_, pattern = ts_fts })
end
do
	vim.pack.add({ { src = "https://github.com/windwp/nvim-ts-autotag" } })
	require("nvim-ts-autotag").setup({})
end
do
	vim.pack.add({ { src = "https://github.com/chrisgrieser/nvim-various-textobjs" } })
	require("various-textobjs").setup({ keymaps = { useDefaults = true } })
end
vim.g["db_ui_use_nerd_fonts"] = 1
do
	vim.pack.add({ { src = "https://github.com/kristijanhusak/vim-dadbod-ui" } })
end
do
	vim.pack.add({ { src = "https://github.com/tpope/vim-dadbod" } })
end
do
	vim.pack.add({ { src = "https://github.com/kristijanhusak/vim-dadbod-completion" } })
end
local function _9_()
	return vim.cmd.DBUIToggle()
end
vim.keymap.set("n", "<leader>td", _9_, { desc = "DBUI toggle" })
do
	vim.pack.add({ { src = "https://github.com/folke/ts-comments.nvim" } })
end
local function _10_()
	return vim.lsp.inlay_hint.enable(true)
end
vim.g["rustaceanvim"] = {
	server = {
		default_settings = { ["rust-analyzer"] = { rustfmt = { extraArgs = { "+nightly" } } } },
		on_attach = _10_,
	},
}
do
	vim.pack.add({ { src = "https://github.com/mrcjkb/rustaceanvim" } })
end
do
	vim.pack.add({ { src = "https://github.com/dchinmay2/clangd_extensions.nvim" } })
end
do
	vim.pack.add({ { src = "https://github.com/b0o/schemastore.nvim" } })
end
do
	local scm = require("schemastore")
	vim.lsp.config("jsonls", { settings = { json = { schemas = scm.json.schemas(), validate = { enable = true } } } })
end
do
	vim.pack.add({ { src = "https://github.com/nvim-neotest/nvim-nio" } })
end
do
	vim.pack.add({ { src = "https://github.com/nvim-neotest/neotest-python" } })
end
do
	vim.pack.add({ { src = "https://github.com/marilari88/neotest-vitest" } })
end
do
	vim.pack.add({ { src = "https://github.com/nvim-neotest/neotest" } })
end
do
	local py = require("neotest-python")
	local vi = require("neotest-vitest")
	local rt = require("rustaceanvim.neotest")
	vim.pack.add({ { src = "https://github.com/nvim-neotest/neotest" } })
	require("neotest").setup({ adapters = { py, vi, rt } })
end
do
	local nt = require("neotest")
	local function _11_()
		return nt.run.run(vim.fn.expand("%"))
	end
	vim.keymap.set("n", "<leader>tf", _11_, { desc = "test file" })
	local function _12_()
		return nt.run.run()
	end
	vim.keymap.set("n", "<leader>tt", _12_, { desc = "test nearest" })
	local function _13_()
		return nt.watch.toggle()
	end
	vim.keymap.set("n", "<leader>tw", _13_, { desc = "test watch" })
	local function _14_()
		return nt.output_panel.toggle()
	end
	vim.keymap.set("n", "<leader>to", _14_, { desc = "test output_panel" })
	local function _15_()
		return nt.summary.toggle()
	end
	vim.keymap.set("n", "<leader>ts", _15_, { desc = "test summary" })
end
do
	vim.pack.add({ { src = "https://github.com/chrisgrieser/nvim-puppeteer" } })
end
do
	vim.pack.add({ { src = "https://github.com/chrisgrieser/nvim-chainsaw" } })
	require("chainsaw").setup({})
end
local cs = require("chainsaw")
local function _16_()
	return cs.variableLog()
end
vim.keymap.set("n", "gll", _16_, { desc = "Chainsaw: log variable" })
local function _17_()
	return cs.objectLog()
end
vim.keymap.set("n", "glo", _17_, { desc = "Chainsaw: log object" })
local function _18_()
	return cs.typeLog()
end
vim.keymap.set("n", "glt", _18_, { desc = "Chainsaw: log type" })
local function _19_()
	return cs.assertLog()
end
vim.keymap.set("n", "gla", _19_, { desc = "Chainsaw: log assert" })
local function _20_()
	return cs.emojiLog()
end
vim.keymap.set("n", "gle", _20_, { desc = "Chainsaw: log emoji" })
local function _21_()
	return cs.messageLog()
end
vim.keymap.set("n", "glm", _21_, { desc = "Chainsaw: log message" })
local function _22_()
	return cs.timeLog()
end
vim.keymap.set("n", "glt", _22_, { desc = "Chainsaw: log time" })
local function _23_()
	return cs.stacktraceLog()
end
vim.keymap.set("n", "gls", _23_, { desc = "Chainsaw: log stacktrace" })
local function _24_()
	return cs.clearLog()
end
vim.keymap.set("n", "glc", _24_, { desc = "Chainsaw: clear log" })
local function _25_()
	return cs.removeLog()
end
vim.keymap.set("n", "glr", _25_, { desc = "Chainsaw: remove log" })
local function _26_()
	return cs.debugLog()
end
return vim.keymap.set("n", "gld", _26_, { desc = "Chainsaw: debug log" })
