-- NOTE: https://github.com/Saghen/blink.cmp/issues/1098

require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
		-- ["<C-u>"] = { "scroll_documentation_up", "fallback" },
		-- ["<C-d>"] = { "scroll_documentation_down", "fallback" },
		["<c-g>"] = {
			function()
				require("blink-cmp").show({ providers = { "ripgrep" } })
			end,
		},
	},

	appearance = {
		nerd_font_variant = "mono",
	},
	-- default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, via `opts_extend`
	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
		},
		per_filetype = {
			lua = { inherit_defaults = true, "lazydev" },
			org = { inherit_defaults = true, "orgmode" },
			gitcommit = { inherit_defaults = true, "emoji" },
			sql = { inherit_defaults = true, "dadbod" },
			codecompanion = {
				inherit_defaults = true,
				"codecompanion",
			},
		},
		providers = {
			orgmode = {
				name = "Org",
				module = "orgmode.org.autocompletion.blink",
				score_offset = 7, -- Tune by preference
			},
			codecompanion = {
				name = "CodeCompanion",
				module = "codecompanion.providers.completion.blink",
				score_offset = 7, -- Tune by preference
			},
			emoji = {
				module = "blink-emoji",
				name = "Emoji",
				score_offset = 5, -- Tune by preference
				opts = {
					insert = true, -- Insert emoji (default) or complete its name
					---@type string|table|fun():table
					trigger = function()
						return { ":" }
					end,
				},
				-- should_show_items = function()
				-- 	return vim.tbl_contains(
				-- 		-- Enable emoji completion only for git commits and markdown.
				-- 		-- By default, enabled for all file-types.
				-- 		{ "gitcommit", "markdown" },
				-- 		vim.o.filetype
				-- 	)
				-- end,
			},
			ripgrep = {
				module = "blink-ripgrep",
				name = "Ripgrep",
				-- (optional) customize how the results are displayed. Many options
				-- are available - make sure your lua LSP is set up so you get
				-- autocompletion help
				transform_items = function(_, items)
					for _, item in ipairs(items) do
						-- example: append a description to easily distinguish rg results
						item.labelDetails = {
							description = "(rg)",
						}
					end
					return items
				end,
			},

			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				fallbacks = { "lsp" },
				score_offset = 5,
			},
			dadbod = {
				name = "Dadbod",
				module = "vim_dadbod_completion.blink",
				score_offset = 9,
			},
			lsp = {
				score_offset = 2, -- Boost/penalize the score of the items
			},
			snippets = {
				enabled = true,
				should_show_items = function(ctx)
					return ctx.trigger.initial_character ~= "."
				end,
				score_offset = 7,
				-- min_keyword_length = 2,
			},
		},
	},

	cmdline = {
		enabled = true,
	},

	signature = { enabled = true },
	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
				kind_resolution = {
					enabled = true,
					blocked_filetypes = { "typescriptreact", "javascriptreact" },
				},
			},
		},
		menu = {
			draw = {
				columns = {
					{ "kind_icon", "label", "label_description", gap = 1 },
					{ "source_name" },
				},
				components = {
					label = {
						text = function(ctx)
							return require("colorful-menu").blink_components_text(ctx)
						end,
						highlight = function(ctx)
							return require("colorful-menu").blink_components_highlight(ctx)
						end,
					},
					kind_icon = {
						text = function(ctx)
							return require("lspkind").symbol_map[ctx.kind] or ""
						end,
					},
				},
			},
		},
	},
})
