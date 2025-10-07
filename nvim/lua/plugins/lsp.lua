return {
    {
        'neovim/nvim-lspconfig',

        event = { "BufReadPre", "BufNewFile" },

        config = function()
            vim.lsp.enable('gopls')

            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {
                                'vim',
                            },
                        },
                    },
                },
            })
            vim.lsp.enable('lua_ls')

            local ruby_lsp_init_options = {}

            if vim.fn.executable('rubocop') == 1 then
                ruby_lsp_init_options.formatter = 'rubocop'
                ruby_lsp_init_options.linters = { 'rubocop' }
            elseif vim.fn.executable('standardrb') == 1 then
                ruby_lsp_init_options.formatter = 'standard'
                ruby_lsp_init_options.linters = { 'standard' }
            end

            vim.lsp.config('ruby_lsp', {
                init_options = ruby_lsp_init_options
            })
            vim.lsp.enable('ruby_lsp')

            if vim.fn.executable('standardrb') == 1 then
                vim.lsp.enable('standardrb')
            end

            vim.lsp.enable('vtsls')
        end,

        keys = {
            {
                "gd",
                function()
                    if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
                        vim.lsp.buf.definition()
                    else
                        require("fzf-lua").grep_cword()
                    end
                end,
                desc = "Go to definition"
            },
            { "K", vim.lsp.buf.hover, desc = "Show documentation" },
        },

        dependencies = {
            {
                'williamboman/mason.nvim',
                opts = {}
            },

            'williamboman/mason-lspconfig.nvim',

            {
                'WhoIsSethDaniel/mason-tool-installer.nvim',
                opts = {
                    ensure_installed = {
                        "gopls",
                        "lua_ls",
                        "ruby_lsp",
                        "vtsls",
                    },
                },
            },

            {
                'j-hui/fidget.nvim',
                opts = {}
            },
        },
    }
}
