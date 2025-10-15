return {
    "folke/sidekick.nvim",

    dependencies = {
        "zbirenbaum/copilot.lua",
    },

    config = function()
        require("sidekick").setup({
            cli = {
                enabled = true,
                mux = {
                    backend = "tmux",
                    enabled = true,
                },
            },

            nes = {
                enabled = true,
                debounce = 100,
            },
        })

        vim.api.nvim_set_hl(0, "SidekickDiffContext", { link = "Comment" })
        vim.api.nvim_set_hl(0, "SidekickDiffAdd", { link = "DiffAdd" })
        vim.api.nvim_set_hl(0, "SidekickDiffDelete", { link = "DiffDelete" })
    end,

    keys = {
        {
            "<CR>",
            function()
                if not require("sidekick").nes_jump_or_apply() then
                    return "<CR>"
                end
            end,
            expr = true,
            mode = "n",
            desc = "Sidekick: Jump or apply Next Edit Suggestion",
        },

        {
            "<c-.>",
            function()
                require("sidekick.cli").toggle()
            end,
            desc = "Sidekick: Toggle AI CLI",
            mode = { "n", "t" },
        },

        {
            "<leader>aa",
            function()
                require("sidekick.cli").toggle("copilot")
            end,
            desc = "Sidekick: Toggle Copilot CLI",
        },
        {
            "<leader>ac",
            function()
                require("sidekick.cli").toggle("claude")
            end,
            desc = "Sidekick: Toggle Claude CLI",
        },
        {
            "<leader>af",
            function()
                require("sidekick.cli").send("{file}")
            end,
            desc = "Sidekick: Send current file",
        },
        {
            "<leader>an",
            function()
                require("sidekick.nes").update()
            end,
            desc = "Sidekick: Request Next Edit Suggestions",
        },
        {
            "<leader>ap",
            function()
                require("sidekick.cli").prompt()
            end,
            desc = "Sidekick: Select prompt",
        },
        {
            "<leader>as",
            function()
                require("sidekick.cli").select()
            end,
            desc = "Sidekick: Select AI CLI tool",
        },
        {
            "<leader>at",
            function()
                require("sidekick.cli").send("{this}")
            end,
            desc = "Sidekick: Send current context",
            mode = { "n", "v" },
        },
        {
            "<leader>av",
            function()
                require("sidekick.cli").send("{selection}")
            end,
            desc = "Sidekick: Send visual selection",
            mode = "v",
        },
    },
}
