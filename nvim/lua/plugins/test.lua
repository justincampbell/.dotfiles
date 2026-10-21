return {
    {
        "vim-test/vim-test",

        init = function()
            -- Keep one terminal split open across runs, bottom of the screen.
            vim.g["test#strategy"] = "neovim_sticky"
            vim.g["test#neovim#term_position"] = "botright 15"
            vim.g["test#neovim_sticky#reopen_window"] = 1
            vim.g["test#neovim_sticky#kill_previous"] = 1
            vim.g["test#preserve_screen"] = 0

            -- From an implementation file, run its test file: ask other.nvim for
            -- the "test" alternate and hand the first existing one to vim-test.
            vim.g["test#custom_alternate_file"] = function()
                local ok, other = pcall(require, "other-nvim")
                if not ok then
                    return ""
                end
                local matches = other.findOther(vim.api.nvim_buf_get_name(0), "test") or {}
                for _, m in ipairs(matches) do
                    if vim.fn.filereadable(m.filename) == 1 then
                        return m.filename
                    end
                end
                return ""
            end
        end,

        -- `update` first so format-on-save runs and the test sees the saved file
        keys = {
            { "<Leader>tt", "<Cmd>update<Bar>TestFile<CR>",    desc = "Run test file" },
            { "<Leader>tr", "<Cmd>update<Bar>TestNearest<CR>", desc = "Run nearest test" },
            { "<Leader>tT", "<Cmd>update<Bar>TestSuite<CR>",   desc = "Run test suite" },
            { "<Leader>tl", "<Cmd>update<Bar>TestLast<CR>",    desc = "Run last test" },
            { "<Leader>tv", "<Cmd>TestVisit<CR>",              desc = "Visit last test file" },
        },
    },
}
