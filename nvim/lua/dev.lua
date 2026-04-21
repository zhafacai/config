-- [nfnl] fnl/dev.fnl
do
  vim.pack.add({{src = "https://github.com/rafamadriz/friendly-snippets"}})
end
do
  vim.pack.add({{src = "https://github.com/chrisgrieser/nvim-scissors"}})
end
do
  local scissors = require("scissors")
  local function _1_()
    return scissors.editSnippet()
  end
  vim.keymap.set("n", "<leader>se", _1_, {desc = "Snippet: Edit"})
  local function _2_()
    return scissors.addNewSnippet()
  end
  vim.keymap.set({"n", "x"}, "<leader>sa", _2_, {desc = "Snippet: Add"})
end
do
  vim.pack.add({{src = "https://github.com/mikavilpas/blink-ripgrep.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/moyiz/blink-emoji.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/xzbdmw/colorful-menu.nvim"}})
  require("colorful-menu").setup({})
end
do
  vim.pack.add({{src = "https://github.com/onsails/lspkind.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/saghen/blink.cmp", version = vim.version.range("*")}})
end
require("zfc.blink")
do
  vim.pack.add({{src = "https://github.com/neovim/nvim-lspconfig"}})
end
do
  local ser = {"tsgo", "lua_ls", "ty", "zls", "clangd", "tailwindcss", "nixd", "jsonls", "org"}
  vim.lsp.enable(ser)
end
do
  vim.pack.add({{src = "https://github.com/mfussenegger/nvim-lint"}})
end
do
  local lint = require("lint")
  local linters = {python = {"ruff"}, markdown = {"rumdl"}}
  local function _3_()
    return lint.try_lint()
  end
  vim.api.nvim_create_autocmd("BufWritePost", {callback = _3_, pattern = "*"})
  lint["linters_by_ft"] = linters
end
do
  vim.pack.add({{src = "https://github.com/folke/lazydev.nvim"}})
  require("lazydev").setup({library = {{path = "${3rd}/luv/library", words = {"vim%.uv"}}}})
end
do
  vim.pack.add({{src = "https://github.com/rachartier/tiny-code-action.nvim"}})
  require("tiny-code-action").setup({backend = "vim", picker = {"buffer", opts = {auto_preview = true, hotkeys = true, hotkeys_mode = "text_based"}}})
end
do
  vim.pack.add({{src = "https://github.com/chrisgrieser/nvim-spider"}})
end
do
  local spider_motion
  local function _4_(_241)
    local m = _241
    return ("<cmd>lua require('spider').motion('" .. m .. "')<CR>")
  end
  spider_motion = _4_
  vim.keymap.set({"n", "o", "x"}, "w", spider_motion("w"), {desc = "Spider: w"})
  vim.keymap.set({"n", "o", "x"}, "e", spider_motion("e"), {desc = "Spider: e"})
  vim.keymap.set({"n", "o", "x"}, "b", spider_motion("b"), {desc = "Spider: b"})
  vim.keymap.set({"n", "o", "x"}, "ge", spider_motion("ge"), {desc = "Spider: ge"})
end
do
  vim.pack.add({{src = "https://github.com/farmergreg/vim-lastplace"}})
end
do
  vim.pack.add({{name = "better_escape", src = "https://github.com/max397574/better-escape.nvim"}})
  require("better_escape").setup({mappings = {t = {j = {k = false}}}})
end
do
  vim.pack.add({{src = "https://github.com/folke/flash.nvim"}})
  require("flash").setup({label = {uppercase = false}})
end
do
  local flash = require("flash")
  local function _5_()
    return flash.jump()
  end
  vim.keymap.set({"n", "x", "o"}, "<c-s>", _5_, {desc = "Flash jump"})
  local function _6_()
    return flash.treesitter()
  end
  vim.keymap.set("n", "S", _6_, {desc = "Flash treesitter"})
  local function _7_()
    return flash.toggle()
  end
  vim.keymap.set("c", "<c-s>", _7_, {desc = "Flash toggle"})
end
do
  vim.pack.add({{src = "https://github.com/nvim-treesitter/nvim-treesitter"}})
end
do
  local ts_fts = {"typescript", "lua", "html", "yaml", "comment", "fennel", "bpftrace", "cpp", "zig", "nix", "python"}
  local nts = require("nvim-treesitter")
  nts.install(ts_fts)
  local function _8_()
    vim.treesitter.start()
    vim.opt["indentexpr"] = "v:lua.require'nvim-treesitter'.indentexpr()"
    return nil
  end
  vim.api.nvim_create_autocmd("FileType", {callback = _8_, pattern = ts_fts})
end
do
  vim.pack.add({{src = "https://github.com/windwp/nvim-ts-autotag"}})
  require("nvim-ts-autotag").setup({})
end
do
  vim.pack.add({{name = "various-textobjs", src = "https://github.com/chrisgrieser/nvim-various-textobjs"}})
  require("various-textobjs").setup({keymaps = {useDefaults = true}})
end
vim.g["db_ui_use_nerd_fonts"] = 1
do
  vim.pack.add({{src = "https://github.com/kristijanhusak/vim-dadbod-ui"}})
end
do
  vim.pack.add({{src = "https://github.com/tpope/vim-dadbod"}})
end
do
  vim.pack.add({{src = "https://github.com/kristijanhusak/vim-dadbod-completion"}})
end
local function _9_()
  return vim.cmd.DBUIToggle()
end
vim.keymap.set("n", "<leader>td", _9_, {desc = "DBUI toggle"})
do
  vim.pack.add({{src = "https://github.com/folke/ts-comments.nvim"}})
end
local function _10_()
  return vim.lsp.inlay_hint.enable(true)
end
vim.g["rustaceanvim"] = {server = {default_settings = {["rust-analyzer"] = {rustfmt = {extraArgs = {"+nightly"}}}}, on_attach = _10_}}
do
  vim.pack.add({{src = "https://github.com/mrcjkb/rustaceanvim"}})
end
local function _11_()
  local function _12_()
    return vim.cmd.RustLsp("codeAction")
  end
  vim.keymap.set("n", "gra", _12_, {buffer = true, desc = "Rust: Code Action"})
  local function _13_()
    return vim.cmd("RustLsp hover actions")
  end
  vim.keymap.set("n", "K", _13_, {buffer = true, desc = "Rust: Hover Actions"})
  local function _14_()
    return vim.cmd("RustLsp hover range")
  end
  vim.keymap.set({"v"}, "K", _14_, {buffer = true, desc = "Rust: Hover Range"})
  local function _15_()
    return vim.cmd.RustLsp("runnables")
  end
  vim.keymap.set("n", "<leader>dr", _15_, {buffer = true, desc = "Rust: Runnables"})
  local function _16_()
    return vim.cmd.RustLsp("debuggables")
  end
  vim.keymap.set("n", "<leader>dd", _16_, {buffer = true, desc = "Rust: Debuggables"})
  local function _17_()
    return vim.cmd.RustLsp("testables")
  end
  vim.keymap.set("n", "<leader>dt", _17_, {buffer = true, desc = "Rust: Testables"})
  local function _18_()
    return vim.cmd.RustLsp("expandMacro")
  end
  vim.keymap.set("n", "<leader>de", _18_, {buffer = true, desc = "Rust: Expand Macro"})
  local function _19_()
    return vim.cmd.RustLsp("moveItem")
  end
  vim.keymap.set("n", "<leader>dm", _19_, {buffer = true, desc = "Rust: Move Item"})
  local function _20_()
    return vim.cmd.RustLsp("renderDiagnostic")
  end
  vim.keymap.set("n", "<leader>dx", _20_, {buffer = true, desc = "Rust: Render Diagnostic"})
  local function _21_()
    return vim.cmd.RustLsp("openDocs")
  end
  vim.keymap.set("n", "<leader>do", _21_, {buffer = true, desc = "Rust: Open Docs"})
  local function _22_()
    return vim.cmd.RustLsp("openCargo")
  end
  vim.keymap.set("n", "<leader>dc", _22_, {buffer = true, desc = "Rust: Open Cargo"})
  local function _23_()
    return vim.cmd.RustLsp("joinLines")
  end
  vim.keymap.set("n", "<leader>dj", _23_, {buffer = true, desc = "Rust: Join Lines"})
  local function _24_()
    return vim.cmd.RustLsp("workspaceSymbol")
  end
  vim.keymap.set("n", "<leader>dw", _24_, {buffer = true, desc = "Rust: Workspace Symbol"})
  local function _25_()
    return vim.cmd.RustLsp("parentModule")
  end
  vim.keymap.set("n", "<leader>dp", _25_, {buffer = true, desc = "Rust: Parent Module"})
  local function _26_()
    return vim.cmd.RustLsp("explainError")
  end
  vim.keymap.set("n", "<leader>dy", _26_, {buffer = true, desc = "Rust: Explain Error"})
  local function _27_()
    return vim.cmd.RustLsp("relatedDiagnostics")
  end
  return vim.keymap.set("n", "<leader>dg", _27_, {buffer = true, desc = "Rust: Related Diagnostics"})
end
vim.api.nvim_create_autocmd("FileType", {callback = _11_, pattern = "rust"})
do
  vim.pack.add({{src = "https://github.com/dchinmay2/clangd_extensions.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/b0o/schemastore.nvim"}})
end
do
  local scm = require("schemastore")
  vim.lsp.config("jsonls", {settings = {json = {schemas = scm.json.schemas(), validate = {enable = true}}}})
end
do
  vim.pack.add({{src = "https://github.com/moonbit-community/moonbit.nvim"}})
  require("moonbit").setup({})
end
do
  vim.pack.add({{src = "https://github.com/nvim-neotest/nvim-nio"}})
end
do
  vim.pack.add({{src = "https://github.com/nvim-neotest/neotest-python"}})
end
do
  vim.pack.add({{src = "https://github.com/marilari88/neotest-vitest"}})
end
do
  vim.pack.add({{src = "https://github.com/nvim-neotest/neotest"}})
end
do
  local py = require("neotest-python")
  local vi = require("neotest-vitest")
  local mn = require("neotest-moonbit")
  local rt = require("rustaceanvim.neotest")
  vim.pack.add({{src = "https://github.com/nvim-neotest/neotest"}})
  require("neotest").setup({adapters = {py, vi, rt, mn}})
end
do
  local nt = require("neotest")
  local function _28_()
    return nt.run.run(vim.fn.expand("%"))
  end
  vim.keymap.set("n", "<leader>tf", _28_, {desc = "test file"})
  local function _29_()
    return nt.run.run()
  end
  vim.keymap.set("n", "<leader>tt", _29_, {desc = "test nearest"})
  local function _30_()
    return nt.watch.toggle()
  end
  vim.keymap.set("n", "<leader>tw", _30_, {desc = "test watch"})
  local function _31_()
    return nt.output_panel.toggle()
  end
  vim.keymap.set("n", "<leader>to", _31_, {desc = "test output_panel"})
  local function _32_()
    return nt.summary.toggle()
  end
  vim.keymap.set("n", "<leader>ts", _32_, {desc = "test summary"})
end
do
  vim.pack.add({{src = "https://github.com/chrisgrieser/nvim-puppeteer"}})
end
do
  vim.pack.add({{name = "chainsaw", src = "https://github.com/chrisgrieser/nvim-chainsaw"}})
  require("chainsaw").setup({})
end
local cs = require("chainsaw")
local function _33_()
  return cs.variableLog()
end
vim.keymap.set("n", "gll", _33_, {desc = "Chainsaw: log variable"})
local function _34_()
  return cs.objectLog()
end
vim.keymap.set("n", "glo", _34_, {desc = "Chainsaw: log object"})
local function _35_()
  return cs.typeLog()
end
vim.keymap.set("n", "glt", _35_, {desc = "Chainsaw: log type"})
local function _36_()
  return cs.assertLog()
end
vim.keymap.set("n", "gla", _36_, {desc = "Chainsaw: log assert"})
local function _37_()
  return cs.emojiLog()
end
vim.keymap.set("n", "gle", _37_, {desc = "Chainsaw: log emoji"})
local function _38_()
  return cs.messageLog()
end
vim.keymap.set("n", "glm", _38_, {desc = "Chainsaw: log message"})
local function _39_()
  return cs.timeLog()
end
vim.keymap.set("n", "glt", _39_, {desc = "Chainsaw: log time"})
local function _40_()
  return cs.stacktraceLog()
end
vim.keymap.set("n", "gls", _40_, {desc = "Chainsaw: log stacktrace"})
local function _41_()
  return cs.clearLog()
end
vim.keymap.set("n", "glc", _41_, {desc = "Chainsaw: clear log"})
local function _42_()
  return cs.removeLog()
end
vim.keymap.set("n", "glr", _42_, {desc = "Chainsaw: remove log"})
local function _43_()
  return cs.debugLog()
end
return vim.keymap.set("n", "gld", _43_, {desc = "Chainsaw: debug log"})
