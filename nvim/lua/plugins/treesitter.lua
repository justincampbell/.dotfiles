return {
    {
        "nvim-treesitter/nvim-treesitter",

        build = ":TSUpdate",

        config = function()
            require('nvim-treesitter.configs').setup({
                auto_install = true,
            })

            -- nvim-treesitter's legacy `master` branch ships a markdown injection
            -- query using the custom `#set-lang-from-info-string!` directive, whose
            -- handler is incompatible with Neovim 0.11+: it passes a capture node
            -- *list* to get_node_text, which calls `node:range()` on a table and
            -- throws "attempt to call method 'range' (a nil value)" from the TS
            -- highlighter. It fires on markdown with fenced code blocks (e.g. while
            -- scrolling fzf-lua previews). Replace it with Neovim's own bundled
            -- markdown injection query (standard @injection.language, no custom
            -- directive); re-register the one fence alias the bundled query lacks.
            vim.treesitter.language.register('go', { 'golang' })
            local core = vim.env.VIMRUNTIME .. '/queries/markdown/injections.scm'
            local ok, lines = pcall(vim.fn.readfile, core)
            if ok and type(lines) == 'table' and #lines > 0 then
                vim.treesitter.query.set('markdown', 'injections', table.concat(lines, '\n'))
            end
        end
    }
}
