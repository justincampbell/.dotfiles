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

                lualine_x = {},

                lualine_y = {},

                lualine_z = {
                    "%2l/%L",
                    -- use_mode_colors = false,
                },
            },
        })
    end,
}
