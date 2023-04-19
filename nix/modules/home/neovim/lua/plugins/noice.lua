return {
    'folke/noice.nvim',
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify"
    },
    opts = {
        lsp = {
            -- override markdown rendering, so that **cmp** and other plugins use **TreeSitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        presets = {
            bottom_search = true, -- classic bottom cmdline for search
            command_palette = true, -- position the command line and popup menu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
        }
    },
}
