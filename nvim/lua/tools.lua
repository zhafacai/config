-- [nfnl] fnl/tools.fnl
do
  vim.pack.add({{src = "https://github.com/nvim-lua/plenary.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/rktjmp/paperplanes.nvim"}})
  require("paperplanes").setup({})
end
do
  vim.pack.add({{src = "https://github.com/NeogitOrg/neogit"}})
  require("neogit").setup({})
end
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", {desc = "Open Neogit"})
do
  vim.pack.add({{src = "https://github.com/esmuellert/codediff.nvim"}})
  require("codediff").setup({})
end
vim.keymap.set("n", "<leader>gd", "<cmd>CodeDiff<CR>", {desc = "Open CodeDiff"})
do
  vim.pack.add({{src = "https://github.com/MagicDuck/grug-far.nvim"}})
  require("grug-far").setup({})
end
vim.keymap.set("n", "<leader>sf", "<cmd>GrugFar<CR>", {desc = "Open GrugFar"})
do
  vim.pack.add({{src = "https://github.com/mikavilpas/yazi.nvim"}})
  require("yazi").setup({})
end
vim.keymap.set("n", "<a-e>", "<cmd>Yazi<cr>", {desc = "Open Yazi"})
do
  vim.pack.add({{src = "https://github.com/nvzone/volt"}})
end
do
  vim.pack.add({{src = "https://github.com/nvzone/floaterm"}})
  require("floaterm").setup({terminals = {{name = "Terminal"}, {name = "Terminal"}, {name = "Terminal"}}})
end
vim.keymap.set({"n", "t"}, "<a-i>", "<CMD>FloatermToggle<CR>", {desc = "Toggle floaterm"})
vim.g["loaded_netrwPlugin"] = 1
do
  vim.pack.add({{src = "https://github.com/stevearc/oil.nvim"}})
  local function _1_()
    vim.g.oil_detail = not vim.g.oil_detail
    local oil = require("oil")
    if vim.g.oil_detail then
      return oil.set_columns({"icon", "permissions", "size", "mtime"})
    else
      return oil.set_columns({"icon"})
    end
  end
  require("oil").setup({keymaps = {q = "actions.close", gq = "q", gd = {callback = _1_, desc = "Toggle file detail view"}}})
end
vim.keymap.set("n", "-", "<CMD>Oil<CR>", {desc = "Open parent directory"})
do
  vim.pack.add({{src = "https://github.com/stevearc/conform.nvim"}})
  require("conform").setup({format_on_save = {timeout_ms = 500, lsp_format = "fallback"}, formatters_by_ft = {lua = {"stylua"}, sh = {"shfmt"}, markdown = {"rumdl"}, toml = {"tombi"}, python = {"black"}, fennel = {"fnlfmt"}, nix = {"nixfmt"}, json = {"jq"}, rust = {"rustfmt"}}})
end
do
  vim.pack.add({{src = "https://github.com/lambdalisue/vim-suda"}})
end
do
  vim.pack.add({{src = "https://github.com/benoror/gpg.nvim"}})
end
do
  vim.pack.add({{src = "https://github.com/HakonHarnes/img-clip.nvim"}})
  require("img-clip").setup({})
end
vim.keymap.set("n", "<leader>p", "<Cmd>PasteImage<CR>", {desc = "Paste image"})
do
  vim.pack.add({{src = "https://github.com/olimorris/codecompanion.nvim"}})
end
do
  local cca = require("codecompanion.adapters")
  local openrouter
  local function _3_()
    return cca.extend("openai_compatible", {schema = {model = {default = "nvidia/nemotron-3-super-120b-a12b:free", choices = {"nvidia/nemotron-3-super-120b-a12b:free", "minimax/minimax-m2.5:free", "arcee-ai/trinity-large-preview:free", "google/gemma-4-26b-a4b-it:free", "google/gemma-4-31b-it:free", "liquid/lfm-2.5-1.2b-instruct:free", "liquid/lfm-2.5-1.2b-thinking:free"}}}, env = {api_key = vim.env.OPENROUTER_API_KEY, chat_url = "/v1/chat/completions", url = "https://openrouter.ai/api"}})
  end
  openrouter = _3_
  vim.pack.add({{src = "https://github.com/olimorris/codecompanion.nvim"}})
  require("codecompanion").setup({interactions = {chat = {adapter = "opencode"}, cli = {agent = "opencode", agents = {opencode = {cmd = "opencode", args = {}, description = "OpenCode Cli", provider = "terminal"}}}, inline = {adapter = "openrouter"}, cmd = {adapter = "opencode"}}, adapters = {http = {openrouter = openrouter}}, prompt_library = {markdown = {dirs = {vim.fn.expand("~/dots/prompts/")}}}})
end
vim.keymap.set({"n", "v"}, "<leader>cp", "<cmd>CodeCompanion<CR>", {desc = "Toggle CodeCompanion panel"})
vim.keymap.set({"n", "v"}, "<leader>cc", "<cmd>CodeCompanionChat<CR>", {desc = "Open CodeCompanion chat"})
vim.keymap.set({"n", "v"}, "<leader>ca", "<cmd>CodeCompanionActions<CR>", {desc = "Open CodeCompanion actions"})
vim.keymap.set({"n", "v"}, "<leader>cr", "<cmd>CodeCompanionReview<CR>", {desc = "Review code with CodeCompanion"})
vim.cmd("cab cc CodeCompanion")
do
  vim.pack.add({{src = "https://github.com/Olical/conjure"}})
end
do
  vim.pack.add({{src = "https://github.com/Olical/nfnl"}})
end
vim.g["conjure#filetypes"] = {"fennel", "scheme"}
return nil
