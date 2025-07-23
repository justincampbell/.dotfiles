return {
	"AndrewRadev/switch.vim",
	config = function()
		vim.g.switch_custom_definitions = {
			{ "==", "!=" },
			{ "true", "false" },
			{ "if", "unless" },
			{ "enable", "disable" },
		}
	end,
}
