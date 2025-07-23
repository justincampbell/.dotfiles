return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                -- enabled = true,
                enabled = false,
                auto_trigger = true,
                -- hide_during_completion = false,
                hide_during_completion = true,
                keymap = {
                    -- accept = "<Tab>",
                    accept = false,
                    next = "<M-]>",
                    prev = "<M-[>",
                },
            },
        },
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
