return {
    {
        "folke/trouble.nvim",

        opts = {
            modes = {
                diagnostics = {
                    auto_close = true,
                    auto_open = true,
                },
            },
        },

        keys = {
            { "tt", "<Cmd>Trouble<CR>",                               desc = "Trouble" },

            { "td", "<Cmd>Trouble diagnostics toggle focus=true<CR>", desc = "Trouble Diagnostics" },
            { "tl", "<Cmd>Trouble loclist toggle focus=true<CR>",     desc = "Trouble Loclist" },
            { "tq", "<Cmd>Trouble quickfix toggle focus=true<CR>",    desc = "Trouble Quickfix" },
            { "ts", "<Cmd>Trouble symbols toggle focus=true<CR>",     desc = "Trouble Symbols" },
        },
    },
}
