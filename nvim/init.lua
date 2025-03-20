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
vim.g.mapleader = " "
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

-- Search/replace
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- TODO move keymaps to another file

-- Keymaps
vim.keymap.set("n", "<c-P>", function()
    require("fzf-lua").files()
end, { silent = true })

vim.keymap.set("n", "gs", ":Switch<CR>", { desc = "Toggle switch" })
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { desc = "Next tab", silent = true })
vim.keymap.set("n", "<Shift><Tab>", ":tabprev<CR>", { desc = "Next tab", silent = true })
vim.keymap.set("v", "<Leader>s", ":sort<CR>", { noremap = true, silent = true })

-- Comments
vim.keymap.set("n", "<Leader>/", "gcc<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<Leader>/", "gc<CR>", { noremap = true, silent = true })
