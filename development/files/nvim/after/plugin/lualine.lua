-- https://github.com/nvim-lualine/lualine.nvim
require("lualine").setup({
    options = {
        component_separators = "",-- { left = '', right = ''},
        section_separators = "",--{ left = '', right = ''},
        theme = "solarized_dark"
    },
    sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', {
            'diagnostics',
            symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
        }},
		lualine_c = {
			{
				'filename',
				path = 3,
			}
		},
		lualine_x = {'encoding', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
})
