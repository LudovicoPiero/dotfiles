-- Telescope
require("telescope").setup()

-- Bufferline
require("bufferline").setup({
	options = {
		mode = "buffers",
		offsets = {
			{ filetype = "NvimTree" },
		},
	},
	highlights = {
		buffer_selected = {
			italic = false,
		},
		indicator_selected = {
			fg = { attribute = "fg", highlight = "Function" },
			italic = false,
		},
	},
})

-- Indent Blankline
require("indent_blankline").setup({
	char = "▏",
	show_trailing_blankline_indent = false,
	show_first_indent_level = false,
	use_treesitter = true,
	show_current_context = false,
})

-- Dashboard
local db = require("dashboard")
db.custom_header = {
	"",
	" ⣽⣿⢣⣿⡟⣽⣿⣿⠃⣲⣿⣿⣸⣷⡻⡇⣿⣿⢇⣿⣿⣿⣏⣎⣸⣦⣠⡞⣾⢧⣿⣿",
	"⣿⡏⣿⡿⢰⣿⣿⡏⣼⣿⣿⡏⠙⣿⣿⣤⡿⣿⢸⣿⣿⢟⡞⣰⣿⣿⡟⣹⢯⣿⣿⣿",
	"⡿⢹⣿⠇⣿⣿⣿⣸⣿⣿⣿⣿⣦⡈⠻⣿⣿⣮⣿⣿⣯⣏⣼⣿⠿⠏⣰⡅⢸⣿⣿⣿",
	"⡀⣼⣿⢰⣿⣿⣇⣿⣿⡿⠛⠛⠛⠛⠄⣘⣿⣿⣿⣿⣿⣿⣶⣿⠿⠛⢾⡇⢸⣿⣿⣿",
	"⠄⣿⡟⢸⣿⣿⢻⣿⣿⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡋⠉⣠⣴⣾⣿⡇⣸⣿⣿⡏",
	"⠄⣿⡇⢸⣿⣿⢸⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠘⢿⣿⠏⠄⣿⣿⣿⣹",
	"⠄⢻⡇⢸⣿⣿⠸⣿⣿⣿⣿⣿⣿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣦⣼⠃⠄⢰⣿⣿⢯⣿",
	"⠄⢸⣿⢸⣿⣿⡄⠙⢿⣿⣿⡿⠁⠄⠄⠄⠄⠉⣿⣿⣿⣿⣿⣿⡏⠄⢀⣾⣿⢯⣿⣿",
	"⣾⣸⣿⠄⣿⣿⡇⠄⠄⠙⢿⣀⠄⠄⠄⠄⠄⣰⣿⣿⣿⣿⣿⠟⠄⠄⣼⡿⢫⣻⣿⣿",
	"⣿⣿⣿⠄⢸⣿⣿⠄⠄⠄⠄⠙⠿⣷⣶⣤⣴⣿⠿⠿⠛⠉⠄⠄⢸⣿⣿⣿⣿⠃⠄⣴ ",
	"",
}
db.custom_center = {
	{
		icon = "  ",
		desc = "Recently latest session                  ",
		shortcut = "SPC s l",
		action = "SessionLoad",
	},
	{
		icon = "  ",
		desc = "Recently opened files                   ",
		action = "DashboardFindHistory",
		shortcut = "SPC f h",
	},
	{
		icon = "  ",
		desc = "Find  File                              ",
		action = "Telescope find_files find_command=rg,--hidden,--files",
		shortcut = "SPC f f",
	},
	{
		icon = "  ",
		desc = "File Browser                            ",
		action = "Telescope file_browser",
		shortcut = "SPC f b",
	},
	{
		icon = "  ",
		desc = "Find  word                              ",
		action = "Telescope live_grep",
		shortcut = "SPC f w",
	},
}
db.custom_footer = {
	"Ludovico Sforza 🚀",
	"SFORZA FAMIGLIA ",
}

-- Lualine
local lualine = require("lualine")
lualine.setup({
	options = {
		icons_enabled = true,
		theme = "palenight",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

-- Nvim-Treesitter
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	ensure_installed = {
		"javascript",
		"typescript",
		"tsx",
		"css",
		"rust",
		"nix",
		"go",
		"lua",
	},
})

require("nvim-tree").setup({
	sort_by = "case_sensitive",
	view = {
		-- side = "right",
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "u", action = "dir_up" },
			},
		},
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})

-- Presence ( Discord Rich Presence )
-- require("presence"):setup(
-- 	{
-- 		-- General options
-- 		auto_update = true,
-- 		neovim_image_text = "The One True Text Editor",
-- 		main_image = "neovim",
-- 		client_id = "793271441293967371",
-- 		log_level = nil,
-- 		debounce_timeout = 10,
-- 		enable_line_number = false,
-- 		blacklist = {},
-- 		buttons = true,
-- 		file_assets = {},
-- 		show_time = true,
-- 		-- Rich Presence text options
-- 		editing_text = "Editing %s",
-- 		file_explorer_text = "Browsing %s",
-- 		git_commit_text = "Committing changes",
-- 		plugin_manager_text = "Managing plugins",
-- 		reading_text = "Reading %s",
-- 		workspace_text = "Working on %s",
-- 		line_number_text = "Line %s out of %s"
-- 	}
-- )

-- Nvim-Web-DevIcons
require("nvim-web-devicons").setup({
	color_icons = true,
	default = true,
})
