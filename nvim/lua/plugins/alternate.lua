return {
    -- TODO: This does nothing so far
    {
        "tpope/vim-projectionist",
        config = function()
            vim.g.projectionist_heuristics = {
                ["go.mod"] = {
                    ["*.go"] = { alternate = "{}_test.go" },
                    ["*_test.go"] = { alternate = "{}.go" },
                },
            }
        end,
        event = "BufEnter",
    },
}
