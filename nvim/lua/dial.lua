vim.pack.add({
	"https://github.com/monaqa/dial.nvim",
})

vim.keymap.set("n", "<C-a>", function()
	require("dial.map").manipulate("increment", "normal")
end)

vim.keymap.set("n", "<C-x>", function()
	require("dial.map").manipulate("decrement", "normal")
end)
local augend = require("dial.augend")

local logical_alias = augend.constant.new({
	elements = { "&&", "||" },
	word = false,
	cyclic = true,
})

local ordinal_numbers = augend.constant.new({
	-- elements through which we cycle. When we increment, we go down
	-- On decrement we go up
	elements = {
		"first",
		"second",
		"third",
		"fourth",
		"fifth",
		"sixth",
		"seventh",
		"eighth",
		"ninth",
		"tenth",
	},
	-- if true, it only matches strings with word boundary. firstDate wouldn't work for example
	word = false,
	-- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
	-- Otherwise nothing will happen when there are no further values
	cyclic = true,
})

local months = augend.constant.new({
	elements = {
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December",
	},
	word = true,
	cyclic = true,
})
require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
		augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
		augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
		augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
		augend.constant.alias.en_weekday, -- Mon, Tue, ..., Sat, Sun
		augend.constant.alias.en_weekday_full, -- Monday, Tuesday, ..., Saturday, Sunday
		ordinal_numbers,
		months,
		augend.constant.alias.bool, -- boolean value (true <-> false)
		augend.constant.alias.Bool, -- boolean value (True <-> False)
		logical_alias,
		augend.constant.new({ elements = { "let", "const" } }),
		augend.hexcolor.new({
			case = "lower",
		}),
		augend.hexcolor.new({
			case = "upper",
		}),
		augend.constant.new({
			elements = { "[ ]", "[x]" },
			word = false,
			cyclic = true,
		}),
		augend.misc.alias.markdown_header,
		augend.semver.alias.semver, -- versioning (v1.1.2)
		augend.constant.new({
			elements = { "and", "or" },
			word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
			cyclic = true, -- "or" is incremented into "and".
		}),
	},
})

-- vim.keymap.set("n", "g<C-a>", function()
-- 	require("dial.map").manipulate("increment", "gnormal")
-- end)
-- vim.keymap.set("n", "g<C-x>", function()
-- 	require("dial.map").manipulate("decrement", "gnormal")
-- end)
-- vim.keymap.set("x", "<C-a>", function()
-- 	require("dial.map").manipulate("increment", "visual")
-- end)
-- vim.keymap.set("x", "<C-x>", function()
-- 	require("dial.map").manipulate("decrement", "visual")
-- end)
-- vim.keymap.set("x", "g<C-a>", function()
-- 	require("dial.map").manipulate("increment", "gvisual")
-- end)
-- vim.keymap.set("x", "g<C-x>", function()
-- 	require("dial.map").manipulate("decrement", "gvisual")
-- end)
