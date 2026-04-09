-- setup for MiniStatusline in _G
require("mini.statusline").setup()
local MiniStatusline = _G.MiniStatusline

-- Spinner symbols for loading animation
local spinner_symbols = {
	"⠋",
	"⠙",
	"⠹",
	"⠸",
	"⠼",
	"⠴",
	"⠦",
	"⠧",
	"⠇",
	"⠏",
}
local spinner_symbols_len = 10

-- Global state for processing and spinner index
local CodeCompanionState = {
	processing = false,
	spinner_index = 1,
}
-- Timer reference for continuous spinner updates
local spinner_timer = nil

-- Function to update spinner index
local update_spinner = function()
	CodeCompanionState.spinner_index = (CodeCompanionState.spinner_index % spinner_symbols_len) + 1
end

-- Function to start the spinner timer
local start_spinner = function()
	CodeCompanionState.processing = true

	-- start timer
	if spinner_timer then
		spinner_timer:stop()
		spinner_timer = nil
	end

	spinner_timer = vim.loop.new_timer()
	if not spinner_timer then
		return
	end

	spinner_timer:start(
		0, -- immediate start
		100, -- interval in milliseconds (adjust for speed)
		vim.schedule_wrap(function()
			update_spinner()
			-- Force statusline redraw
			vim.cmd("redrawstatus")
		end)
	)
end

-- Function to stop the spinner timer
local stop_spinner = function()
	CodeCompanionState.processing = false
	-- stop timer
	if spinner_timer then
		spinner_timer:stop()
		spinner_timer = nil
	end
	CodeCompanionState.spinner_index = 1
end

-- Create autocommands to track CodeCompanion requests
local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "CodeCompanionRequest*",
	group = group,
	callback = function(request)
		if request.match == "CodeCompanionRequestStarted" then
			start_spinner()
		elseif request.match == "CodeCompanionRequestFinished" then
			stop_spinner()
		end
	end,
})

-- Function to get the current spinner symbol
local get_spinner_symbol = function()
	if CodeCompanionState.processing then
		return spinner_symbols[CodeCompanionState.spinner_index]
	else
		return ""
	end
end

-- Custom section for CodeCompanion status
local section_codecompanion = function(opts)
	opts = opts or {}
	local trunc_width = opts.trunc_width or 40

	local spinner = get_spinner_symbol()

	if spinner ~= "" then
		-- Truncate if needed
		if string.len(spinner) > trunc_width then
			return string.sub(spinner, 1, trunc_width - 3) .. "..."
		else
			return spinner
		end
	else
		return ""
	end
end

-- Define the statusline content
local statusline = function()
	local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
	local git = MiniStatusline.section_git({ trunc_width = 40 })
	local diff = MiniStatusline.section_diff({ trunc_width = 75 })
	local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
	local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
	local filename = MiniStatusline.section_filename({ trunc_width = 140 })
	local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
	local location = MiniStatusline.section_location({ trunc_width = 75 })
	local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

	-- Get CodeCompanion spinner
	local codecompanion = section_codecompanion()

	-- Combine all sections
	return MiniStatusline.combine_groups({
		{ hl = mode_hl, strings = { mode } },
		{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
		"%<", -- Mark general truncate point
		{ hl = "MiniStatuslineFilename", strings = { filename } },
		"%=", -- End left alignment
		{ hl = "MiniStatuslineCodeCompanion", strings = { codecompanion } }, -- Add CodeCompanion section
		{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
		{ hl = mode_hl, strings = { search, location } },
	})
end

-- Setup mini.statusline with custom content
require("mini.statusline").setup({
	content = {
		-- Content for active window
		active = statusline,
		-- Content for inactive window(s)
		inactive = function()
			return MiniStatusline.default_inactive()
		end,
	},
})

-- Define highlight group for CodeCompanion section
vim.api.nvim_set_hl(0, "MiniStatuslineCodeCompanion", { link = "@comment.warning" })
