vim.pack.add({
	{ src = "https://github.com/nvim-orgmode/orgmode" },
	{ src = "https://github.com/hamidi-dev/org-super-agenda.nvim" },
	{ src = "https://github.com/zhafacai/denote.nvim", version = "uiselect" },
	{ src = "https://github.com/nvim-orgmode/telescope-orgmode.nvim" },
	{ src = "https://github.com/nvim-orgmode/org-bullets.nvim" },
})

local od = vim.fn.expand("~/notes")

require("denote").setup({
	filetype = "org",
	directory = od .. "/denote/",
	prompts = { "title", "keywords" },
	integrations = {
		oil = true,
	},
})

require("orgmode").setup({
	org_agenda_files = od .. "/agenda/*",
	org_default_notes_file = od .. "/refile.org",
	org_startup_indented = true,
	hyperlinks = {
		sources = {
			require("denote.extensions.orgmode"):new({
				---@diagnostic disable-next-line: assign-type-mismatch
				files = od .. "/denote/",
			}),
		},
	},
	mappings = {
		global = {
			---@diagnostic disable-next-line: assign-type-mismatch
			org_agenda = false,
		},
	},
})

require("org-super-agenda").setup({
	org_files = { od .. "/refile.org" },
})

require("org-bullets").setup()

vim.keymap.set("n", "<leader>oa", "<cmd>OrgSuperAgenda<cr>")
vim.keymap.set("n", "<leader>oA", "<cmd>OrgSuperAgenda!<cr>")

-- Denote:
vim.keymap.set("n", "<leader>nn", "<cmd>Denote<cr>")
vim.keymap.set("n", "<leader>nl", "<cmd>DenoteInsertLink<cr>")
vim.keymap.set("n", "<leader>nb", "<cmd>DenoteBackLinks<cr>")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "org",
	callback = function(ev)
		local tom = require("telescope-orgmode")
		tom.setup({ adapter = "snacks" })
		vim.keymap.set("n", "<leader>sh", tom.search_headings, { desc = "Org headlines", buf = ev.buf })
		vim.keymap.set("n", "<leader>st", tom.search_tags, { desc = "Org tags", buf = ev.buf })
		vim.keymap.set("n", "<leader>sr", tom.refile_heading, { desc = "Org refile", buf = ev.buf })
		vim.keymap.set("n", "<leader>sl", tom.insert_link, { desc = "Org insert link", buf = ev.buf })
	end,
})
