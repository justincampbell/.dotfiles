return {
    {
        'neovim/nvim-lspconfig',

        lazy = false,

        config = function()
            vim.lsp.enable('gopls')

            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' },
                        },
                    },
                },
            })
            vim.lsp.enable('lua_ls')

            -- Start ruby_lsp eagerly if in a Ruby project, attach to Ruby buffers via autocmd
            if vim.uv.fs_stat('Gemfile') then
                local ruby_lsp_config = {
                    name = 'ruby_lsp',
                    cmd = { 'mise', 'exec', '--', 'ruby-lsp' },
                    root_dir = vim.fn.getcwd(),
                }

                vim.defer_fn(function()
                    vim.lsp.start(ruby_lsp_config)
                end, 0)

                vim.api.nvim_create_autocmd('FileType', {
                    pattern = 'ruby',
                    callback = function()
                        vim.lsp.start(ruby_lsp_config)
                    end,
                })
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
            { "gr", function() require("fzf-lua").lsp_references() end, desc = "Find references" },
            { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
            { "gy", vim.lsp.buf.type_definition, desc = "Go to type definition" },
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
