return {
    {
        "hrsh7th/nvim-cmp",

        opts = function(_, opts)
            local cmp = require("cmp")

            opts.completion = { completeopt = 'menu,menuone,noinsert' }

            -- TODO: have not seen this work yet
            opts.expand = function(args)
                vim.snippet.expand(args.body)
            end

            opts.sources = cmp.config.sources({
                { name = "luasnip",  priority = 1000 },
                { name = "nvim_lsp", priority = 750 },
                { name = "buffer",   priority = 500 },
                { name = "path",     priority = 250 },
            })

            opts.mapping = cmp.mapping.preset.insert({
                ['<Tab>'] = function(fallback)
                    if cmp.visible() then
                        cmp.confirm()
                    else
                        fallback()
                    end
                end,

                ['<CR>'] = cmp.mapping.confirm({ select = true }),

                ['<Up>'] = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end,

                ['<Down>'] = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end,
            })
        end,

        dependencies = {
            'L3MON4D3/LuaSnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'saadparwaiz1/cmp_luasnip',
        }
    }
}
