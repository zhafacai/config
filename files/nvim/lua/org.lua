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
    require("orgmode").setup({org_agenda_files = {fd("/agenda/*")}, mappings = {agenda = {org_agenda_schedule = "s", org_agenda_deadline = "d"}}, org_hide_emphasis_markers = true, org_agenda_custom_commands = {a = {description = "Agenda", types = {{type = "agenda"}, {match = "+TODO=\"NEXT\"", org_agenda_overriding_header = "Tasks", type = "tags_todo"}, {match = "+TODO=\"TODO\"", org_agenda_overriding_header = "Process", type = "tags_todo"}, {match = "+TODO=\"WAIT\"", org_agenda_overriding_header = "Wait", type = "tags_todo"}, {match = "+TODO=\"SMDY\"", org_agenda_overriding_header = "Someday", type = "tags_todo"}, {match = "DEADLINE>=\"<+1d>\"&DEADLINE<\"<+2d>\"|SCHEDULED>=\"<+1d>\"&SCHEDULED<\"<+2d>\"", org_agenda_overriding_header = "Due Tomorrow", type = "tags_todo"}, {match = "DEADLINE<\"<today>\"&DEADLINE>\"<-7d>\"|SCHEDULED<\"<today>\"&SCHEDULED>\"<-7d>\"", org_agenda_overriding_header = "Overdue", type = "tags_todo"}, {match = "DEADLINE<\"<-7d>\"|SCHEDULED<\"<-7d>\"", org_agenda_overriding_header = "Long Overdue", type = "tags_todo"}}}}, org_capture_templates = {d = {description = "Deadline", template = "* TODO %?\nDEADLINE: %T"}, s = {description = "Schedule", template = "* TODO %?\nSCHEDULED: %T"}, t = {description = "Todo", template = "* TODO %?\n"}, n = {description = "Next", template = "* NEXT %?\n"}}, org_log_into_drawer = "LOGBOOK", org_todo_keywords = {"TODO(t)", "NEXT(n)", "WAIT(w)", "SMDY(s)", "|", "DONE(d)", "CNCL(c)"}, org_default_notes_file = fd("/agenda/refile.org"), win_split_mode = {"float", 0.88}, org_startup_indented = true, ui = {agenda = {preview_window = {border = "single"}}}, hyperlinks = {sources = {require("denote.extensions.orgmode"):new({files = fd("/denote/")})}}, org_agenda_start_on_weekday = false})
  end
  do
    vim.pack.add({{src = "https://github.com/hamidi-dev/org-super-agenda.nvim", version = "develop"}})
    local function _2_(i)
      return (i.scheduled and i.scheduled:is_today())
    end
    local function _3_(i)
      return (i.scheduled and (i.scheduled:days_from_today() == 1))
    end
    local function _4_(i)
      return (i.deadline and (i.todo_state ~= "DONE"))
    end
    local function _5_(i)
      return ((i.priority == "A") and (i.deadline or i.scheduled))
    end
    local function _6_(i)
      return ((i.todo_state ~= "DONE") and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past())))
    end
    local function _7_(i)
      local days = (require("org-super-agenda.config").get().upcoming_days or 10)
      local d1 = (i.deadline and i.deadline:days_from_today())
      local d2 = (i.scheduled and i.scheduled:days_from_today())
      return (((d1 and (d1 >= 0)) and (d1 <= days)) or ((d2 and (d2 >= 0)) and (d2 <= days)))
    end
    require("org-super-agenda").setup({groups = {{matcher = _2_, name = "\240\159\147\133 Today", sort = {by = "scheduled_time", order = "asc"}}, {matcher = _3_, name = "\240\159\151\147\239\184\143 Tomorrow", sort = {by = "scheduled_time", order = "asc"}}, {matcher = _4_, name = "\226\152\160\239\184\143 Deadlines", sort = {by = "deadline", order = "asc"}}, {matcher = _5_, name = "\226\173\144 Important", sort = {by = "date_nearest", order = "asc"}}, {matcher = _6_, name = "\226\143\179 Overdue", sort = {by = "date_nearest", order = "asc"}}, {matcher = _7_, name = "\240\159\147\134 Upcoming", sort = {by = "date_nearest", order = "asc"}}}, ["todo-states"] = {{color = "#E46876", fields = {"filename", "todo", "headline", "priority", "date", "tags"}, keymap = "ot", name = "TODO", strike_through = false}, {color = "#FF9E3B", fields = {"filename", "todo", "headline", "priority", "date", "tags"}, keymap = "on", name = "NEXT", strike_through = false}, {color = "#957FB8", fields = {"filename", "todo", "headline", "priority", "date", "tags"}, keymap = "ow", name = "WAIT", strike_through = false}, {color = "#D27E99", fields = {"filename", "todo", "headline", "priority", "date", "tags"}, keymap = "os", name = "SMDY", strike_through = false}, {color = "#76946A", fields = {"filename", "todo", "headline", "priority", "date", "tags"}, keymap = "od", name = "DONE", strike_through = true}, {color = "#8383A8", fields = {"filename", "todo", "headline", "priority", "date", "tags"}, keymap = "oc", name = "CNCL", strike_through = true}}})
  end
  do
    vim.pack.add({{src = "https://github.com/nvim-orgmode/telescope-orgmode.nvim"}})
    require("telescope-orgmode").setup({adapter = "snacks"})
  end
  vim.pack.add({{src = "https://github.com/nvim-orgmode/org-bullets.nvim"}})
  require("org-bullets").setup({})
end
vim.keymap.set("n", "<leader>oA", "<cmd>OrgSuperAgenda!<CR>")
vim.keymap.set("n", "<leader>nn", "<cmd>Denote<CR>", {desc = "Denote"})
vim.keymap.set("n", "<leader>ns", "<cmd>DenoteSearch<CR>", {desc = "DenoteSearch"})
vim.keymap.set("n", "<leader>nl", "<cmd>DenoteInsertLink<CR>", {desc = "DenoteInsertLink"})
vim.keymap.set("n", "<leader>nb", "<cmd>DenoteBacklinks<CR>", {desc = "DenoteBacklinks"})
local function _8_()
  local tom = require("telescope-orgmode")
  local function _9_()
    local orgmode = require("orgmode")
    return orgmode.action("org_mappings.meta_return")
  end
  vim.keymap.set("i", "<A-CR>", _9_, {buffer = true, silent = true})
  vim.keymap.set("n", "<leader>sh", tom.search_headings, {desc = "Org headlines", buffer = true})
  vim.keymap.set("n", "<leader>st", tom.search_tags, {desc = "Org tags", buffer = true})
  vim.keymap.set("n", "<leader>sr", tom.refile_heading, {desc = "Org refile", buffer = true})
  return vim.keymap.set("n", "<leader>sl", tom.insert_link, {desc = "Org insert link", buffer = true})
end
return {vim.api.nvim_create_autocmd("FileType", {callback = _8_, group = vim.api.nvim_create_augroup("OrgMaps", {clear = true}), pattern = "org"})}
