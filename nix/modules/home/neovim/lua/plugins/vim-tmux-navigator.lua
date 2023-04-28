return {
    'christoomey/vim-tmux-navigator',
    config = function()
        vim.g.tmux_navigator_save_on_switch = 2
        vim.g.tmux_navigator_disable_when_zoomed = true
        vim.g.tmux_navigator_no_mappings = true
        vim.keymap.set("n", "<C-h>", ":<C-U>TmuxNavigateLeft<cr>", { remap = false, silent = true })
        vim.keymap.set("n", "<C-S-Left>", ":<C-U>TmuxNavigateLeft<cr>", { remap = false, silent = true })
        vim.keymap.set("n", "<C-j>", ":<C-U>TmuxNavigateDown<cr>", { remap = false, silent = true })
        vim.keymap.set("n", "<C-S-Down>", ":<C-U>TmuxNavigateDown<cr>", { remap = false, silent = true })
        vim.keymap.set("n", "<C-k>", ":<C-U>TmuxNavigateUp<cr>", { remap = false, silent = true })
        vim.keymap.set("n", "<C-S-Up>", ":<C-U>TmuxNavigateUp<cr>", { remap = false, silent = true })
        vim.keymap.set("n", "<C-l>", ":<C-U>TmuxNavigateRight<cr>", { remap = false, silent = true })
        vim.keymap.set("n", "<C-S-Right>", ":<C-U>TmuxNavigateRight<cr>", { remap = false, silent = true })
        vim.keymap.set("n", "<C-,>", ":<C-U>TmuxNavigatePrevious<cr>", { remap = false, silent = true })
    end
}
