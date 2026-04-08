-- [nfnl] fnl/mini.fnl
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.statusline"}})
  require("mini.statusline").setup({})
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
  vim.pack.add({{src = "https://github.com/nvim-mini/mini-git"}})
  require("mini.git").setup({})
end
do
  vim.pack.add({{src = "https://github.com/kylechui/nvim-surround"}})
end
do
  vim.pack.add({{src = "https://github.com/windwp/nvim-autopairs"}})
  require("nvim-autopairs").setup({disable_filetype = {"fennel"}})
end
do
  vim.pack.add({{src = "https://github.com/nvim-mini/mini.sessions"}})
  require("mini.sessions").setup({})
end
do
  local keys = {{action = ":lua Snacks.dashboard.pick('files')", desc = "Find File", icon = "\239\128\130 ", key = "<space><space>"}, {action = ":Neogit", desc = "Git", icon = "\238\153\157 ", key = "n"}, {action = "<cmd>OrgSuperAgenda!<CR>", desc = "Agenda", icon = "\243\176\160\174 ", key = "a"}, {action = "<cmd>Org capture<CR>", desc = "Capture", icon = "\238\184\145 ", key = "c"}, {action = ":lua Snacks.dashboard.pick('live_grep')", desc = "Live Grep", icon = "\239\128\162 ", key = "f"}, {action = ":lua Snacks.dashboard.pick('oldfiles')", desc = "Recent Files", icon = "\239\131\133 ", key = "r"}, {action = ":lua Snacks.dashboard.pick('files', {cwd = '~/dots'})", desc = "Config", icon = "\239\144\163 ", key = "C"}, {desc = "Restore Session", icon = "\238\141\136 ", key = "s", action = ":lua MiniSessions.read()"}, {action = ":qa", desc = "Quit", icon = "\239\144\166 ", key = "q"}}
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
  return Snacks.picker.autocmds()
end
vim.keymap.set("n", "<leader>ha", _6_, {desc = "Autocmds"})
local function _7_()
  return Snacks.picker.commands()
end
vim.keymap.set("n", "<leader>hc", _7_, {desc = "Commands"})
local function _8_()
  return Snacks.picker.diagnostics()
end
vim.keymap.set("n", "<leader>hd", _8_, {desc = "Diagnostics"})
local function _9_()
  return Snacks.picker.highlight()
end
vim.keymap.set("n", "<leader>hl", _9_, {desc = "Highlights"})
local function _10_()
  return Snacks.picker.keymaps()
end
vim.keymap.set("n", "<leader>hk", _10_, {desc = "Keymaps"})
local function _11_()
  return Snacks.picker.marks()
end
vim.keymap.set("n", "<leader>hm", _11_, {desc = "Marks"})
local function _12_()
  return Snacks.picker.colorschemes()
end
vim.keymap.set("n", "<leader>ho", _12_, {desc = "Colorschemes"})
local function _13_()
  return Snacks.gitbrowse()
end
vim.keymap.set("n", "<leader>gb", _13_, {desc = "Git browse"})
local function _14_()
  return Snacks.scratch()
end
vim.keymap.set("n", "<leader>ss", _14_, {desc = "Scratch buffer"})
local function _15_()
  return Snacks.scratch.select()
end
vim.keymap.set("n", "<leader>sS", _15_, {desc = "Select scratch"})
local function _16_()
  return Snacks.picker.icons()
end
vim.keymap.set("n", "<leader>sI", _16_, {desc = "Icons"})
local function _17_(_241)
  vim.b[_241.buf]["miniindentscope_disable"] = true
  return nil
end
return vim.api.nvim_create_autocmd("User", {callback = _17_, pattern = "SnacksDashboardOpened"})
