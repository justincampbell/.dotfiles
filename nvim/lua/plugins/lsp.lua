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

            -- ruby-lsp is a gem, not a Mason package: `gem install ruby-lsp` per Ruby.
            -- Run through mise so the project's Ruby (and its gems) is used. Root is
            -- found from lspconfig's markers (Gemfile, .git); with neither it runs
            -- in single-file mode, so scratch files still get an LSP.
            vim.lsp.config('ruby_lsp', {
                cmd = { 'mise', 'exec', '--', 'ruby-lsp' },
            })
            vim.lsp.enable('ruby_lsp')

            vim.lsp.enable('vtsls')

            -- Ruby formatting: ruby-lsp formats via rubocop when rubocop is in the
            -- project's bundle. Otherwise fall back to the global rubocop with only
            -- the Layout cops, so scratch files still get whitespace/indent fixes
            -- without any style rewrites.
            local function format_ruby(bufnr)
                if #vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/formatting' }) > 0 then
                    vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 5000 })
                    return
                end
                local name = vim.api.nvim_buf_get_name(bufnr)
                local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                local res = vim.system(
                    { 'mise', 'exec', '--', 'rubocop', '-a', '--only', 'Layout', '--stdin', name, '--stderr', '--format', 'quiet' },
                    { cwd = vim.fs.dirname(name), stdin = table.concat(lines, '\n') .. '\n', text = true }
                ):wait(10000)
                -- exit 1 = offenses left (or syntax error, in which case stdout echoes the input)
                if res.code > 1 or not res.stdout or res.stdout == '' then
                    return
                end
                local new = vim.split(res.stdout, '\n', { plain = true })
                if new[#new] == '' then
                    table.remove(new)
                end
                if not vim.deep_equal(lines, new) then
                    local view = vim.fn.winsaveview()
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new)
                    vim.fn.winrestview(view)
                end
            end

            -- FileType re-fires on :e, so clear the buffer's hook before re-adding it
            local fmt_group = vim.api.nvim_create_augroup('RubyFormat', { clear = true })

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'ruby',
                callback = function(args)
                    vim.keymap.set('n', '<Leader>=', function() format_ruby(args.buf) end,
                        { buffer = args.buf, desc = 'Format buffer' })
                    vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = args.buf })
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = fmt_group,
                        buffer = args.buf,
                        callback = function() format_ruby(args.buf) end,
                    })
                end,
            })
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
            { "<Leader>=", function() vim.lsp.buf.format({ async = true }) end, desc = "Format buffer" },
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
