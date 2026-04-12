-- [nfnl] fnl/org.fnl
do
  local od = vim.fn.expand("~/notes")
  local fd
  local function _1_(_241)
    return (od .. _241)
  end
  fd = _1_
  do
    vim.pack.add({{src = "https://github.com/zhafacai/denote.nvim", version = "uiselect"}})
    require("denote").setup({filetype = "org", directory = fd("/denote/"), prompts = {"title", "keywords"}, integrations = {oil = true}})
  end
  do
    vim.pack.add({{src = "https://github.com/nvim-orgmode/orgmode"}})
    require("orgmode").setup({org_agenda_files = {fd("/agenda/*"), fd("/agenda/refile.org")}, org_hide_emphasis_markers = true, org_agenda_custom_commands = {a = {description = "Agenda", types = {{match = "+TODO='NEXT'", org_agenda_overriding_header = "Tasks", type = "tags_todo"}, {match = "+TODO='TODO'", org_agenda_overriding_header = "Process", type = "tags_todo"}, {match = "DEADLINE>=\"<+1d>\"&DEADLINE<\"<+2d>\"", org_agenda_overriding_header = "Due Tomorrow", type = "tags_todo"}, {match = "DEADLINE<\"<today>\"&DEADLINE>\"<-7d>\"|SCHEDULED<\"<today>\"&SCHEDULED>\"<-7d>\"", org_agenda_overriding_header = "Overdue", type = "tags_todo"}, {match = "DEADLINE<\"<-7d>\"|SCHEDULED<\"<-7d>\"", org_agenda_overriding_header = "Long Overdue", type = "tags_todo"}}}}, org_capture_templates = {d = {description = "Deadline", template = "* TODO %?\nDEADLINE: %T"}, s = {description = "Schedule", template = "* TODO %?\nSCHEDULED: %T"}, t = {description = "Todo", template = "* TODO %?\n"}, n = {description = "Next", template = "* NEXT %?\n"}}, org_log_into_drawer = "LOGBOOK", org_todo_keywords = {"TODO(t)", "NEXT(n)", "|", "DONE(d)", "CNCL(c)"}, org_default_notes_file = fd("/agenda/refile.org"), win_split_mode = {"float", 0.88}, org_startup_indented = true, ui = {agenda = {preview_window = {border = "single"}}}, hyperlinks = {sources = {require("denote.extensions.orgmode"):new({files = fd("/denote/")})}}, org_agenda_start_on_weekday = false})
  end
  do
    vim.pack.add({{src = "https://github.com/nvim-orgmode/telescope-orgmode.nvim"}})
  end
  vim.pack.add({{src = "https://github.com/nvim-orgmode/org-bullets.nvim"}})
  require("org-bullets").setup({})
end
vim.keymap.set("n", "<leader>nn", "<cmd>Denote<CR>", {desc = "Denote"})
vim.keymap.set("n", "<leader>ns", "<cmd>DenoteSearch<CR>", {desc = "DenoteSearch"})
vim.keymap.set("n", "<leader>nl", "<cmd>DenoteInsertLink<CR>", {desc = "DenoteInsertLink"})
vim.keymap.set("n", "<leader>nb", "<cmd>DenoteBacklinks<CR>", {desc = "DenoteBacklinks"})
local function _2_(ev)
  local tom = require("telescope-orgmode")
  tom.setup({adapter = "snacks"})
  vim.keymap.set("n", "<leader>sh", tom.search_headings, {desc = "Org headlines", buffer = ev.buf})
  vim.keymap.set("n", "<leader>st", tom.search_tags, {desc = "Org tags", buffer = ev.buf})
  vim.keymap.set("n", "<leader>sr", tom.refile_heading, {desc = "Org refile", buffer = ev.buf})
  return vim.keymap.set("n", "<leader>sl", tom.insert_link, {desc = "Org insert link", buffer = ev.buf})
end
return vim.api.nvim_create_autocmd("FileType", {callback = _2_, pattern = "org"})
