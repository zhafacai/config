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
    require("orgmode").setup({org_agenda_files = {fd("/agenda/*"), fd("/refile.org")}, org_default_notes_file = fd("/refile.org"), org_startup_indented = true, hyperlinks = {sources = {require("denote.extensions.orgmode"):new({files = fd("/denote/")})}}, mappings = {global = {org_agenda = false}}})
  end
  do
    vim.pack.add({{src = "https://github.com/zhafacai/org-super-agenda.nvim", version = "fix/close-window-cleanly"}})
    require("org-super-agenda").setup({org_files = {fd("/agenda/*"), fd("/refile.org")}})
  end
  do
    vim.pack.add({{src = "https://github.com/nvim-orgmode/telescope-orgmode.nvim"}})
  end
  vim.pack.add({{src = "https://github.com/nvim-orgmode/org-bullets.nvim"}})
  require("org-bullets").setup({})
end
vim.keymap.set("n", "<leader>oa", "<cmd>OrgSuperAgenda<CR>")
vim.keymap.set("n", "<leader>oA", "<cmd>OrgSuperAgenda!<CR>")
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
