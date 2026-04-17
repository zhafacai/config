-- [nfnl] fnl/mini.fnl
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.statusline"}})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.icons"}})
  require("mini.icons").setup({})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.diff"}})
  require("mini.diff").setup({})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.operators"}})
  require("mini.operators").setup({replace = {prefix = "R", reindent_linewise = true}})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.align"}})
  require("mini.align").setup({})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.cursorword"}})
  require("mini.cursorword").setup({})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.indentscope"}})
  require("mini.indentscope").setup({})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.move"}})
  require("mini.move").setup({})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.splitjoin"}})
  require("mini.splitjoin").setup({})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.notify"}})
  require("mini.notify").setup({})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.bracketed"}})
  require("mini.bracketed").setup({treesitter = {suffix = ""}})
end
do
  vim.pack.add({{name = "mini.git", src = "https://github.com/nvim-mini/mini-git"}})
  require("mini.git").setup({})
end
do
  vim.pack.add({{src = "https://github.com/kylechui/nvim-surround"}})
end
do
  vim.pack.add({{src = "https://github.com/windwp/nvim-autopairs"}})
  require("nvim-autopairs").setup({})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.sessions"}})
  require("mini.sessions").setup({})
end
vim.keymap.set("n", "<leader>S", "<cmd>mksession<CR>")
do
  local keys = {{action = ":lua Snacks.dashboard.pick('files')", desc = "File", icon = "\239\128\130 ", key = "<space><space>"}, {action = ":lua Snacks.dashboard.pick('live_grep')", desc = "Grep", icon = "\243\177\161\180 ", key = "f"}, {action = ":lua Snacks.dashboard.pick('oldfiles')", desc = "Recent", icon = "\239\131\133 ", key = "r"}, {action = ":lua Snacks.picker.help()", desc = "Help", icon = "\243\176\158\139 ", key = "h"}, {action = ":Neogit", desc = "Git", icon = "\238\153\157 ", key = "g"}, {action = "<cmd>Org agenda<CR>", desc = "Agenda", icon = "\243\177\168\139 ", key = "a"}, {action = ":Denote", desc = "Note", icon = "\238\185\180 ", key = "n"}, {action = "<cmd>Org capture<CR>", desc = "Capture", icon = "\243\176\155\168 ", key = "c"}, {action = ":lua Snacks.dashboard.pick('files', {cwd = '~/dots'})", desc = "Config", icon = "\239\144\163 ", key = "C"}, {desc = "Session", icon = "\238\141\136 ", key = "s", action = ":lua MiniSessions.read()"}, {action = ":qa", desc = "Quit", icon = "\239\144\166 ", key = "q"}}
  local sections = {{icon = "\239\132\156 ", indent = 2, padding = 1, section = "keys", title = "Keymaps"}, {icon = "\239\133\155 ", indent = 2, padding = 1, section = "recent_files", title = "Recent Files"}, {icon = "\239\129\188 ", indent = 2, padding = 1, section = "projects", title = "Projects"}}
  vim.pack.add({{src = "https://github.com/folke/snacks.nvim"}})
  require("snacks").setup({bigfile = {enabled = true}, image = {enabled = true}, scratch = {enabled = true}, dashboard = {enabled = true, preset = {keys = keys}, sections = sections}, picker = {enabled = true}})
end
local function _1_()
  return Snacks.picker.smart()
end
vim.keymap.set("n", "<leader><leader>", _1_, {desc = "Smart picker"})
local function _2_()
  return Snacks.picker.grep()
end
vim.keymap.set("n", "<leader>f", _2_, {desc = "Grep"})
local function _3_()
  return Snacks.picker.help()
end
vim.keymap.set("n", "<leader>hh", _3_, {desc = "Help"})
local function _4_()
  return MiniNotify.show_history()
end
vim.keymap.set("n", "<leader>hn", _4_, {desc = "Notifications"})
local function _5_()
  return Snacks.picker.registers()
end
vim.keymap.set("n", "<leader>hr", _5_, {desc = "Registers"})
local function _6_()
  return Snacks.picker.buffers()
end
vim.keymap.set("n", "<leader>hb", _6_, {desc = "Buffers"})
local function _7_()
  return Snacks.picker.autocmds()
end
vim.keymap.set("n", "<leader>ha", _7_, {desc = "Autocmds"})
local function _8_()
  return Snacks.picker.commands()
end
vim.keymap.set("n", "<leader>hc", _8_, {desc = "Commands"})
local function _9_()
  return Snacks.picker.command_history()
end
vim.keymap.set("n", "<leader>hH", _9_, {desc = "CommandHistory"})
local function _10_()
  return Snacks.picker.diagnostics()
end
vim.keymap.set("n", "<leader>hd", _10_, {desc = "Diagnostics"})
local function _11_()
  return Snacks.picker.highlights()
end
vim.keymap.set("n", "<leader>hl", _11_, {desc = "Highlights"})
local function _12_()
  return Snacks.picker.keymaps()
end
vim.keymap.set("n", "<leader>hk", _12_, {desc = "Keymaps"})
local function _13_()
  return Snacks.picker.marks()
end
vim.keymap.set("n", "<leader>hm", _13_, {desc = "Marks"})
local function _14_()
  return Snacks.picker.colorschemes()
end
vim.keymap.set("n", "<leader>hs", _14_, {desc = "Colorschemes"})
local function _15_()
  return Snacks.lazygit()
end
vim.keymap.set("n", "<leader>gl", _15_, {desc = "Lazygit"})
local function _16_()
  return Snacks.gitbrowse()
end
vim.keymap.set("n", "<leader>gb", _16_, {desc = "Git browse"})
local function _17_()
  return Snacks.scratch()
end
vim.keymap.set("n", "<leader>ss", _17_, {desc = "Scratch buffer"})
local function _18_()
  return Snacks.picker.todo_comments()
end
vim.keymap.set("n", "<leader>st", _18_, {desc = "Todo Comments"})
local function _19_()
  return Snacks.picker.scratch({win = {input = {keys = {["<c-n>"] = {"list_down", mode = {"i"}}, ["<c-x>"] = {"scratch_delete", mode = {"n", "i"}}}}}})
end
vim.keymap.set("n", "<leader>sS", _19_, {desc = "Select scratch"})
local function _20_()
  return Snacks.picker.icons()
end
vim.keymap.set("n", "<leader>sI", _20_, {desc = "Icons"})
local function _21_()
  return Snacks.picker.gh_issue()
end
vim.keymap.set("n", "<leader>gi", _21_, {desc = "Issue"})
local function _22_()
  return Snacks.picker.gh_issue({state = "all"})
end
vim.keymap.set("n", "<leader>gI", _22_, {desc = "Issue All"})
local function _23_()
  return Snacks.picker.gh_pr()
end
vim.keymap.set("n", "<leader>gp", _23_, {desc = "Pr"})
local function _24_()
  return Snacks.picker.gh_pr({state = "all"})
end
vim.keymap.set("n", "<leader>gP", _24_, {desc = "Pr All"})
local function _25_()
  vim.b["miniindentscope_disable"] = true
  return nil
end
vim.api.nvim_create_autocmd("User", {callback = _25_, pattern = "SnacksDashboardOpened"})
return require("zfc.mini")
