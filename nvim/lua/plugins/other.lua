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
                showMissingFiles = true,
            })
        end,

        keys = {
            { "<Leader>o",  "<Cmd>Other<CR>",           "List all alternate files" },
            { "<Leader>oo", "<Cmd>Other<CR>",           "List all alternate files" },
            { "<Leader>ot", "<Cmd>Other test<CR>",      "Open test file" },
            { "<Leader>of", "<Cmd>Other factories<CR>", "Open factory file" },
            { "<Leader>ov", "<Cmd>Other view<CR>",      "Open view file" },
            { "<Leader>oc", "<Cmd>OtherClear<CR>",      "Clear alternate file cache" },
        }
    }
}
