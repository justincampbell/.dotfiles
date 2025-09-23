return {
    {
        'neovim/nvim-lspconfig',

        event = { "BufReadPre", "BufNewFile" },

        config = function()
            local lspconfig = require('lspconfig')

            lspconfig.gopls.setup({})

            lspconfig.lua_ls.setup({
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

            local ruby_lsp_config = {
                init_options = {}
            }

            if vim.fn.executable('rubocop') == 1 then
                ruby_lsp_config.init_options.formatter = 'rubocop'
                ruby_lsp_config.init_options.linters = { 'rubocop' }
            elseif vim.fn.executable('standardrb') == 1 then
                ruby_lsp_config.init_options.formatter = 'standard'
                ruby_lsp_config.init_options.linters = { 'standard' }
            end

            lspconfig.ruby_lsp.setup(ruby_lsp_config)

            if vim.fn.executable('standardrb') == 1 then
                lspconfig.standardrb.setup({})
            end

            lspconfig.vtsls.setup({})
        end,

        keys = {
            { "gd", function()
                if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
                    vim.lsp.buf.definition()
                else
                    require("fzf-lua").grep_cword()
                end
            end, desc = "Go to definition" },
            { "K",  vim.lsp.buf.hover,      desc = "Show documentation" },
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
