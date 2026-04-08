vim.pack.add({
	{ src = "https://github.com/nvim-orgmode/orgmode" },
	{ src = "https://github.com/hamidi-dev/org-super-agenda.nvim" },
	{ src = "https://github.com/cvigilv/denote.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-orgmode/telescope-orgmode.nvim" },
	{ src = "https://github.com/nvim-orgmode/org-bullets.nvim" },
})

-- local org_dir = vim.fn.expand("~/notes")

vim.g.denote = {
	filetype = "org",
	directory = "~/orgfiles/",
	prompts = { "title", "keywords" },
	integrations = {
		oil = true,
		telescope = true,
	},
}
require("orgmode").setup({
	org_agenda_files = "~/orgfiles/**/*",
	org_default_notes_file = "~/orgfiles/refile.org",
	org_startup_indented = true,
	hyperlinks = {
		sources = {
			require("denote.extensions.orgmode"):new({
				---@diagnostic disable-next-line: assign-type-mismatch
				files = vim.g.denote.directory,
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
	org_files = { "~/orgfiles/refile.org" },
})

require("org-bullets").setup()

vim.keymap.set("n", "<leader>oa", "<cmd>OrgSuperAgenda<cr>")
vim.keymap.set("n", "<leader>oA", "<cmd>OrgSuperAgenda!<cr>")

-- Denote:
-- TODO: fork this and replace telescope with snacks
vim.keymap.set("n", "<leader>nn", "<cmd>Denote<cr>")
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope denote search<cr>")

vim.api.nvim_create_autocmd("FileType", {

	pattern = "org",
	callback = function(ev)
		local tom = require("telescope-orgmode")
		tom.setup({ adapter = "snacks" })
		vim.keymap.set("n", "<leader>si", "<cmd>Telescope denote insert-link<cr>", { buf = ev.buf })
		vim.keymap.set("n", "<leader>sb", "<cmd>Telescope denote backlinks<cr>", { buf = ev.buf })

		vim.keymap.set("n", "<leader>sh", tom.search_headings, { desc = "Org headlines", buf = ev.buf })
		vim.keymap.set("n", "<leader>st", tom.search_tags, { desc = "Org tags", buf = ev.buf })
		vim.keymap.set("n", "<leader>sr", tom.refile_heading, { desc = "Org refile", buf = ev.buf })
		vim.keymap.set("n", "<leader>sl", tom.insert_link, { desc = "Org insert link", buf = ev.buf })
	end,
})
