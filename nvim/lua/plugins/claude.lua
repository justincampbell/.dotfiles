return {
    {
        "greggh/claude-code.nvim",

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        config = function()
            require("claude-code").setup()
        end
    },
}
