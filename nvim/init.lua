-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Leader
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Initialize lazy.nvim and all plugins
require("lazy").setup({
    spec = { { import = "plugins" } },
    install = { colorscheme = { "railscasts" } },
    checker = { enabled = true, notify = false },
})

-- UI
vim.opt.number = true
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 5
vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.fixeol = true
vim.opt.autoread = true

-- Diagnostics
-- vim.diagnostic.config({
--     signs = true,
--     virtual_text = false,
-- })

-- Search/replace
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Auto-reload files when changed on disk
vim.opt.autoread = true
vim.opt.updatetime = 1000
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "ModeChanged" }, {
    pattern = "*",
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
        end
    end,
})

-- TODO move keymaps to another file

-- Keymaps
vim.keymap.set("n", "<c-P>", function()
    require("fzf-lua").files()
end, { silent = true })

vim.keymap.set("n", "gs", ":Switch<CR>", { desc = "Toggle switch" })
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { desc = "Next tab", silent = true })
vim.keymap.set("n", "<S-Tab>", ":tabprev<CR>", { desc = "Prev tab", silent = true })
vim.keymap.set("v", "<Leader>s", ":sort<CR>", { noremap = true, silent = true })

-- Comments
vim.keymap.set("n", "<Leader>/", "gcc<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<Leader>/", "gc<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("ts_imports", { clear = true }),
    pattern = { "*.tsx,*.ts" },
    callback = function()
        -- vim.lsp.buf.code_action({ apply = true, context = { only = { "source.removeUnusedImports" }, diagnostics = {} } })
        vim.lsp.buf.code_action({ apply = true, context = { only = { "source.addMissingImports.ts" }, diagnostics = {} } })
        -- vim.lsp.buf.code_action({ apply = true, context = { only = { "source.sortImports" }, diagnostics = {} } })
        -- vim.lsp.buf.code_action({ apply = true, context = { only = { "source.removeUnusedImports" }, diagnostics = {} } })
        -- vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll.ts" }, diagnostics = {} } })
        -- local actions = {
        --     "source.removeUnusedImports",
        --     "source.addMissingImports.ts",
        --     "source.sortImports",
        --     "source.fixAll.ts",
        -- }
        -- for i = 1, #actions do
        --     vim.defer_fn(function()
        --         vim.lsp.buf.code_action { apply = true, context = { only = { actions[i] } } }
        --     end, i * 60)
        -- end
    end,
})

-- Show trailing whitespace as dots
vim.opt.listchars = { trail = '·' }
vim.opt.list = true

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})
