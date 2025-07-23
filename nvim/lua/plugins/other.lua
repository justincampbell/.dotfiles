return {
    {
        "rgroli/other.nvim",

        config = function()
            require("other-nvim").setup({
                mappings = {
                    "golang",
                    "rails",
                    "react",
                },
            })
        end,

        keys = {
            { "<Leader>o",  "<Cmd>Other<CR>",       "Open alternate file" },
            { "<Leader>os", "<Cmd>OtherSplit<CR>",  "Open alternate file in horizontal split" },
            { "<Leader>ov", "<Cmd>OtherVSplit<CR>", "Open alternate file in vertical split" },
            { "<Leader>ot", "<Cmd>OtherTabNew<CR>", "Open alternate file in new tab" },
        }
    }
}
