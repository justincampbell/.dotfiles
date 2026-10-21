return {
    {
        "rgroli/other.nvim",

        config = function()
            require("other-nvim").setup({
                mappings = {
                    "golang",
                    "rails",
                    "react",

                    -- Plain Ruby projects (gems, exercises): lib/ <-> spec/ or test/
                    {
                        pattern = "/lib/(.*).rb",
                        target = {
                            { context = "test", target = "/spec/%1_spec.rb" },
                            { context = "test", target = "/spec/lib/%1_spec.rb" },
                            { context = "test", target = "/test/%1_test.rb" },
                            { context = "test", target = "/test/lib/%1_test.rb" },
                        },
                    },
                    {
                        pattern = "/spec/(.*)_spec.rb",
                        target = {
                            { context = "source", target = "/lib/%1.rb" },
                        },
                    },
                    {
                        pattern = "/test/(.*)_test.rb",
                        target = {
                            { context = "source", target = "/lib/%1.rb" },
                        },
                    },
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
