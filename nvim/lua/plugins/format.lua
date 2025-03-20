return {
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                go = { "goimports" }
            },

            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            }
        }
    }
}
