return {
    {
        'stevearc/conform.nvim',

        opts = {
            formatters_by_ft = {
                eruby = { "htmlbeautifier" },
                go = { "goimports" },
                html = { "htmlbeautifier" },
                ruby = { "standardrb", lsp_format = "prefer" },
            },

            default_format_opts = {
                lsp_format = "fallback",
            },

            format_on_save = {
                timeout_ms = 2000,
            },

            notify_on_error = true,

            formatters = {
                htmlbeautifier = {
                    append_args = {
                        "--keep-blank-lines", "1",
                    },
                }
            },
        }
    }
}
