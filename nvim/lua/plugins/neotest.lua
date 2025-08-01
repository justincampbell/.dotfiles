return {
    {
        "nvim-neotest/neotest",

        dependencies = {
            "antoinemadec/FixCursorHold.nvim",
            "folke/trouble.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            "nvim-treesitter/nvim-treesitter",

            "fredrikaverpil/neotest-golang",
            "marilari88/neotest-vitest",
            "nvim-neotest/neotest-jest",
            "zidhuss/neotest-minitest",
        },

        config = function()
            local neotest = require("neotest")

            neotest.setup({
                adapters = {
                    require("neotest-golang"),
                    require("neotest-jest"),
                    require("neotest-minitest"),
                    require("neotest-vitest"),
                },

                -- discovery = { enabled = false },
                -- output = { open_on_run = true },
                status = { virtual_text = true },

                -- quickfix = {
                -- enable = true,

                --     open = function()
                --         require("trouble").open({
                --             mode = "quickfix",
                --             focus = false
                --         })
                --     end,
                -- },
                --
            })

            -- Create an autocommand to save files before neotest runs tests
            vim.api.nvim_create_autocmd("User", {
                pattern = "NeotestPre*",
                callback = function()
                    vim.cmd("silent! wall")
                end,
            })
        end,

        keys = {
            {
                "<leader>t",
                "",
                desc = "+test"
            },

            {
                "<leader>tt",
                function()
                    vim.cmd("silent! wall")
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "Run File (Neotest)"
            },

            {
                "<leader>tT",
                function()
                    vim.cmd("silent! wall")
                    require("neotest").run.run(vim.uv.cwd())
                end,
                desc = "Run All Test Files (Neotest)"
            },

            {
                "<leader>tr",
                function()
                    vim.cmd("silent! wall")
                    require("neotest").run.run()
                end,
                desc = "Run Nearest (Neotest)"
            },

            {
                "<leader>tl",
                function()
                    vim.cmd("silent! wall")
                    require("neotest").run.run_last()
                end,
                desc = "Run Last (Neotest)"
            },

            {
                "<leader>tw",
                function()
                    vim.cmd("silent! wall")
                    require("neotest").watch.toggle(vim.fn.expand("%"))
                end,
                desc = "Toggle Watch (Neotest)"
            },

            {
                "<leader>ts",
                function() require("neotest").summary.toggle() end,
                desc = "Toggle Summary (Neotest)"
            },

            {
                "<leader>to",
                function()
                    require("neotest").output.open({
                        enter = true,
                        auto_close = true
                    })
                end,
                desc = "Show Output (Neotest)"
            },

            {
                "<leader>tO",
                function() require("neotest").output_panel.toggle() end,
                desc = "Toggle Output Panel (Neotest)"
            },

            {
                "<leader>tS",
                function() require("neotest").run.stop() end,
                desc = "Stop (Neotest)"
            },
        },
    }
}
