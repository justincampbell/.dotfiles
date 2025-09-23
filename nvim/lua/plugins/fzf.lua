return {
    {
        "ibhagwan/fzf-lua",
        config = function()
            fzf = require('fzf-lua')
            fzf.setup({})
            fzf.register_ui_select()
        end,
        keys = {
            { "<c-P>", function() require("fzf-lua").files() end, desc = "Find files" },
            { "<c-F>", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
            { "<leader>f", function() require("fzf-lua").grep_cword() end, desc = "Grep word under cursor" },
            { "<leader>f", function() require("fzf-lua").grep_visual() end, mode = "v", desc = "Grep visual selection" },
        },
    }
}
