return {
    {
        'stevearc/conform.nvim',

        opts = function()
            local formatters_by_ft = {
                eruby = { "htmlbeautifier" },
                go = { "goimports" },
                html = { "htmlbeautifier" },
            }

            if vim.fn.executable('rubocop') == 1 then
                formatters_by_ft.ruby = { "rubocop", lsp_format = "prefer" }
            elseif vim.fn.executable('standardrb') == 1 then
                formatters_by_ft.ruby = { "standardrb", lsp_format = "prefer" }
            else
                formatters_by_ft.ruby = { lsp_format = "prefer" }
            end

            return {
                formatters_by_ft = formatters_by_ft,

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
        end
    }
}
