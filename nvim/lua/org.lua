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
    require("orgmode").setup({org_agenda_files = {fd("/agenda/*")}, mappings = {agenda = {org_agenda_schedule = "s", org_agenda_deadline = "d"}, org = {org_meta_return = "<a-cr>"}}, org_hide_emphasis_markers = true, org_agenda_custom_commands = {a = {description = "Agenda", types = {{type = "agenda"}, {match = "+TODO=\"NEXT\"", org_agenda_overriding_header = "Tasks", type = "tags_todo"}, {match = "+TODO=\"TODO\"", org_agenda_overriding_header = "Process", type = "tags_todo"}, {match = "DEADLINE>=\"<+1d>\"&DEADLINE<\"<+2d>\"|SCHEDULED>=\"<+1d>\"&SCHEDULED<\"<+2d>\"", org_agenda_overriding_header = "Due Tomorrow", type = "tags_todo"}, {match = "DEADLINE<\"<today>\"&DEADLINE>\"<-7d>\"|SCHEDULED<\"<today>\"&SCHEDULED>\"<-7d>\"", org_agenda_overriding_header = "Overdue", type = "tags_todo"}, {match = "DEADLINE<\"<-7d>\"|SCHEDULED<\"<-7d>\"", org_agenda_overriding_header = "Long Overdue", type = "tags_todo"}}}}, org_capture_templates = {d = {description = "Deadline", template = "* TODO %?\nDEADLINE: %T"}, s = {description = "Schedule", template = "* TODO %?\nSCHEDULED: %T"}, t = {description = "Todo", template = "* TODO %?\n"}, n = {description = "Next", template = "* NEXT %?\n"}}, org_log_into_drawer = "LOGBOOK", org_todo_keywords = {"TODO(t)", "NEXT(n)", "|", "DONE(d)", "CNCL(c)"}, org_default_notes_file = fd("/agenda/refile.org"), win_split_mode = {"float", 0.88}, org_startup_indented = true, ui = {agenda = {preview_window = {border = "single"}}}, hyperlinks = {sources = {require("denote.extensions.orgmode"):new({files = fd("/denote/")})}}, org_agenda_start_on_weekday = false})
  end
  do
    vim.pack.add({{src = "https://github.com/nvim-orgmode/telescope-orgmode.nvim"}})
    require("telescope-orgmode").setup({adapter = "snacks"})
  end
  vim.pack.add({{src = "https://github.com/nvim-orgmode/org-bullets.nvim"}})
  require("org-bullets").setup({})
end
vim.keymap.set("n", "<leader>nn", "<cmd>Denote<CR>", {desc = "Denote"})
vim.keymap.set("n", "<leader>ns", "<cmd>DenoteSearch<CR>", {desc = "DenoteSearch"})
vim.keymap.set("n", "<leader>nl", "<cmd>DenoteInsertLink<CR>", {desc = "DenoteInsertLink"})
vim.keymap.set("n", "<leader>nb", "<cmd>DenoteBacklinks<CR>", {desc = "DenoteBacklinks"})
local function _2_()
  local tom = require("telescope-orgmode")
  local function _3_()
    local orgmode = require("orgmode")
    return orgmode.action("org_mappings.meta_return")
  end
  vim.keymap.set("i", "<S-CR>", _3_, {buffer = true, silent = true})
  vim.keymap.set("n", "<leader>sh", tom.search_headings, {desc = "Org headlines", buffer = true})
  vim.keymap.set("n", "<leader>st", tom.search_tags, {desc = "Org tags", buffer = true})
  vim.keymap.set("n", "<leader>sr", tom.refile_heading, {desc = "Org refile", buffer = true})
  return vim.keymap.set("n", "<leader>sl", tom.insert_link, {desc = "Org insert link", buffer = true})
end
return {vim.api.nvim_create_autocmd("FileType", {callback = _2_, group = vim.api.nvim_create_augroup("OrgMaps", {clear = true}), pattern = "org"})}
