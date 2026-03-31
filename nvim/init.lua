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
    change_detection = { enabled = true, notify = false },
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
vim.diagnostic.config({
    virtual_text = false,
    float = {
        border = 'rounded',
        format = function(diagnostic)
            -- Strip ANSI color codes
            return diagnostic.message:gsub('\27%[[0-9;]*m', '')
        end,
    },
})

vim.api.nvim_create_autocmd('CursorMoved', {
    pattern = '*',
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = 'line', border = 'rounded', header = '', source = 'always' })
    end,
})

-- Quickfix
vim.keymap.set('n', '<Leader>q', function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd('cclose')
    else
        vim.diagnostic.setqflist()
        vim.cmd('copen')
    end
end, { desc = 'Toggle quickfix' })

vim.keymap.set('n', ']q', ':cnext<CR>', { desc = 'Next quickfix item' })
vim.keymap.set('n', '[q', ':cprev<CR>', { desc = 'Previous quickfix item' })

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

-- Keymaps
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { desc = "Next tab", silent = true })
vim.keymap.set("n", "<S-Tab>", ":tabprev<CR>", { desc = "Prev tab", silent = true })
vim.keymap.set("n", "<Leader>td", ":tab split<CR>", { desc = "Duplicate tab", silent = true })
vim.keymap.set("v", "<Leader>s", ":sort<CR>", { noremap = true, silent = true })

-- Show trailing whitespace as dots, tabs as subtle indicators
vim.opt.listchars = { trail = '·', tab = '  ' }
vim.opt.list = true
