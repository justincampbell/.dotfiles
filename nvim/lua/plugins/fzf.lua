return {
    {
        "ibhagwan/fzf-lua",
        config = function()
            fzf = require('fzf-lua')
            fzf.setup({})
            fzf.register_ui_select()
        end,
    }
}
