return {
    "nvim-lualine/lualine.nvim",

    config = function()
        local theme = require('lualine.themes.16color')
        theme.normal.a.bg = 'black'
        theme.normal.b.bg = 'black'
        theme.normal.c.bg = 'black'

        require('lualine').setup({
            options = {
                theme = theme,

                section_separators = {
                    left = "",
                    right = "",
                },

                component_separators = {
                    left = "",
                    right = "",
                },
            },

            sections = {
                lualine_a = {
                    "lsp_status",
                    -- use_mode_colors = false,
                },

                lualine_b = {
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        -- colored = false,
                    },
                },

                lualine_c = {
                    "filename",
                },

                lualine_x = {
                    {
                        function()
                            -- Check all buffers for running test signs
                            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                                if vim.api.nvim_buf_is_loaded(bufnr) then
                                    local signs = vim.fn.sign_getplaced(bufnr, { group = "neotest-status" })
                                    for _, sign_list in ipairs(signs) do
                                        for _, sign in ipairs(sign_list.signs or {}) do
                                            if sign.name == "neotest_running" then
                                                return "Testing 🔄"
                                            end
                                        end
                                    end
                                end
                            end
                            return ""
                        end,
                    },
                },

                lualine_y = {},

                lualine_z = {
                    "%2l/%L",
                    -- use_mode_colors = false,
                },
            },
        })
    end,
}
