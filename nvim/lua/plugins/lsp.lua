return {
    {
        'neovim/nvim-lspconfig',

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

            lspconfig.ruby_lsp.setup({
                init_options = {
                    formatter = 'standard',
                    linters = { 'standard' },
                },
            })

            lspconfig.standardrb.setup({})

            lspconfig.vtsls.setup({})
        end,

        dependencies = {
            {
                'williamboman/mason.nvim',
                opts = {}
            },

            'williamboman/mason-lspconfig.nvim',

            {
                'WhoIsSethDaniel/mason-tool-installer.nvim',
                ensure_installed = {
                    "gopls",
                    "ruby_lsp",
                    "vtsls",
                },
            },

            {
                'j-hui/fidget.nvim',
                opts = {}
            },
        },
    }
}
