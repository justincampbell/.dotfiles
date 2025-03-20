return {
	{
		"zbirenbaum/copilot.lua",
	},

	{
		-- "CopilotC-Nvim/CopilotChat.nvim",
		dir = "~/Code/CopilotC-Nvim/CopilotChat.nvim", -- local dev
		build = "make tiktoken",
		dependencies = {
			-- { "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
		},
		opts = {
			auto_insert_mode = true,
			debug = true,
		},
	},
}
