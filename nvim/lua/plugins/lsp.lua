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
        end,

        dependencies = {
            { 'williamboman/mason.nvim', opts = {} },
            'williamboman/mason-lspconfig.nvim',
            {
                'WhoIsSethDaniel/mason-tool-installer.nvim',
                ensure_installed = { "gopls" },
            },

            { 'j-hui/fidget.nvim',       opts = {} },

            'hrsh7th/cmp-nvim-lsp',
        },
    }
}
