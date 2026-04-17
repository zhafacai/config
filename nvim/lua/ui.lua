-- [nfnl] fnl/ui.fnl
do
  vim.pack.add({{src = "https://github.com/b0o/incline.nvim"}})
  require("incline").setup({})
end
do
  vim.pack.add({{src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim"}})
  require("tiny-inline-diagnostic").setup({})
end
vim.diagnostic.config({virtual_text = false})
vim.diagnostic.config({float = {source = true}, severity_sort = true, signs = {severity = {min = vim.diagnostic.severity.HINT}, text = {[vim.diagnostic.severity.ERROR] = "\239\129\151", [vim.diagnostic.severity.HINT] = "\238\169\161", [vim.diagnostic.severity.INFO] = "\239\129\154", [vim.diagnostic.severity.WARN] = "\239\129\177"}}, underline = {severity = {min = vim.diagnostic.severity.INFO}}, update_in_insert = true})
do
  vim.pack.add({{src = "https://github.com/OXY2DEV/helpview.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/OXY2DEV/markview.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/folke/which-key.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/kevinhwang91/nvim-bqf"}})
end
do
  vim.pack.add({{src = "https://github.com/Bekaboo/dropbar.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/nacro90/numb.nvim"}})
  require("numb").setup({})
end
do
  vim.pack.add({{src = "https://github.com/lewis6991/satellite.nvim"}})
  require("satellite").setup({})
end
do
  vim.pack.add({{src = "https://github.com/aileot/emission.nvim"}})
  require("emission").setup({attach = {excluded_filetypes = {"oil"}}})
end
do
  vim.pack.add({{src = "https://github.com/uga-rosa/ccc.nvim"}})
  require("ccc").setup({})
end
do
  vim.pack.add({{name = "colorizer", src = "https://github.com/catgoose/nvim-colorizer.lua"}})
  require("colorizer").setup({})
end
do
  vim.pack.add({{name = "hlslens", src = "https://github.com/kevinhwang91/nvim-hlslens"}})
  require("hlslens").setup({})
end
do
  local hlslens = "<Cmd>lua require('hlslens').start()<CR>"
  vim.keymap.set("n", "n", ("<Cmd>execute('normal! ' . v:count1 . 'n')<CR>" .. hlslens), {desc = "Search next with hlslens"})
  vim.keymap.set("n", "N", ("<Cmd>execute('normal! ' . v:count1 . 'N')<CR>" .. hlslens), {desc = "Search prev with hlslens"})
  vim.keymap.set("n", "*", ("*" .. hlslens), {desc = "Search word forward"})
  vim.keymap.set("n", "#", ("#" .. hlslens), {desc = "Search word backward"})
  vim.keymap.set("n", "g*", ("g*" .. hlslens), {desc = "Search word forward (no bounds)"})
  vim.keymap.set("n", "g#", ("g#" .. hlslens), {desc = "Search word backward (no bounds)"})
end
do
  vim.pack.add({{name = "origami", src = "https://github.com/chrisgrieser/nvim-origami"}})
  require("origami").setup({})
end
do
  vim.pack.add({{src = "https://github.com/folke/todo-comments.nvim"}})
  require("todo-comments").setup({})
end
do
  local todo = require("todo-comments")
  local function _1_()
    return todo.jump_next()
  end
  vim.keymap.set("n", "]t", _1_, {desc = "Next Todo Comment"})
  local function _2_()
    return todo.jump_prev()
  end
  vim.keymap.set("n", "[t", _2_, {desc = "Previous Todo Comment"})
end
do
  vim.pack.add({{src = "https://github.com/sainnhe/everforest"}})
end
vim.g["everforest_background"] = "hard"
do
  vim.pack.add({{src = "https://github.com/rebelot/kanagawa.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/nyoom-engineering/oxocarbon.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/folke/tokyonight.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/miikanissi/modus-themes.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/AlexvZyl/nordic.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/ellisonleao/gruvbox.nvim"}})
end
do
  vim.pack.add({{name = "catppuccin", src = "https://github.com/catppuccin/nvim"}})
end
do
  vim.pack.add({{name = "everviolet", src = "https://github.com/everviolet/nvim"}})
end
do
  vim.pack.add({{name = "ember", src = "https://github.com/ember-theme/nvim"}})
end
local light = {"ember-light", "evergarden-summer", "catppuccin-latte", "tokyonight-day", "modus_operandi", "kanagawa-lotus", "gruvbox", "oxocarbon", "everforest"}
local dark = {"ember-soft", "ember", "evergarden-fall", "evergarden-spring", "evergarden-winter", "evergarden", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha", "catppuccin-nvim", "catppuccin", "gruvbox", "nordic", "modus", "modus_vivendi", "tokyonight-moon", "tokyonight-night", "tokyonight-storm", "tokyonight", "oxocarbon", "kanagawa-dragon", "kanagawa-wave", "kanagawa", "everforest"}
local hour = tonumber(os.date("%H"))
local bg
if ((hour >= 7) and (hour < 19)) then
  bg = "light"
else
  bg = "dark"
end
local themes
if ((hour >= 7) and (hour < 19)) then
  themes = light
else
  themes = dark
end
local _ = math.randomseed(os.time())
local idx = (1 + math.random(#themes))
local theme = themes[idx]
vim.opt["background"] = bg
return vim.cmd.colorscheme(theme)
