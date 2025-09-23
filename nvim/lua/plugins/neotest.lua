return {
    {
        "nvim-neotest/neotest",

        dependencies = {
            "antoinemadec/FixCursorHold.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            "nvim-treesitter/nvim-treesitter",

            "fredrikaverpil/neotest-golang",
            "marilari88/neotest-vitest",
            "nvim-neotest/neotest-jest",
            "olimorris/neotest-rspec",
            "zidhuss/neotest-minitest",
        },

        config = function()
            local neotest = require("neotest")

            neotest.setup({
                adapters = {
                    require("neotest-golang"),
                    require("neotest-jest"),
                    require("neotest-rspec"),
                    require("neotest-minitest"),
                    require("neotest-vitest"),
                },

                discovery = {
                    enabled = false
                },

                status = {
                    virtual_text = true,
                    signs = true,
                },

                output = {
                    open_on_run = false,
                },
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
