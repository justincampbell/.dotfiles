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
            { "<leader>f", function() require("fzf-lua").builtin() end, desc = "Fzf commands" },
            { "<leader>fw", function() require("fzf-lua").grep_cword() end, desc = "Find word under cursor" },
            { "<leader>fw", function() require("fzf-lua").grep_visual() end, mode = "v", desc = "Find word (visual)" },
            { "<leader>fg", function() require("fzf-lua").git_status() end, desc = "Git status" },
            { "<leader>fc", function() require("fzf-lua").git_commits() end, desc = "Git commits" },
            { "<leader>fr", function() require("fzf-lua").resume() end, desc = "Resume last search" },
            { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find files" },
            { "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, desc = "Document symbols" },
        },
    }
}
