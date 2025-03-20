return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			theme = "16color",

			section_separators = {
				left = "",
				right = "",
			},

			component_separators = {
				left = "",
				right = "",
			},
		},

		sections = {
			lualine_a = {
				"lsp_status",
				use_mode_colors = false,
			},

			lualine_b = {
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					colored = false,
				},
			},

			lualine_c = {
				"filename",
			},

			lualine_x = {},

			lualine_y = {},

			lualine_z = {
				"%2l/%L",
				use_mode_colors = false,
			},
		},
	},
}
