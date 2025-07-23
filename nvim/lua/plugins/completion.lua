return {
    {
        "saghen/blink.cmp",
        version = "*",

        dependencies = {
            "fang2hou/blink-copilot",
        },

        opts = {
            completion = {
                documentation = { auto_show = true },
                ghost_text = { enabled = true },
                trigger = { show_on_blocked_trigger_characters = {} },
            },

            fuzzy = {
                implementation = "prefer_rust"
            },

            keymap = {
                ["<CR>"] = { "select_and_accept", "fallback" },
                ["<Tab>"] = { "select_and_accept", "fallback" }
            },

            sources = {
                default = {
                    "copilot",
                    "lsp",
                    "buffer",
                    "path"
                },

                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        async = true,
                        score_offset = 100,
                    },
                },
            },

            signature = { enabled = true },
        },
    }
}
