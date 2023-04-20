return {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        local icons = require("magicmonty.icons")
        local colors = require("magicmonty.theme").colors
        local todo = require("todo-comments")

        todo.setup({
            keywords = {
                FIX = { icon = icons.todo.Fix, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                TODO = { icon = icons.todo.Todo, color = "info" },
                HACK = { icon = icons.todo.Hack, color = "warning" },
                WARN = { icon = icons.todo.Warn, color = "warning", alt = { "XXX", "WARNING" } },
                PERF = { icon = icons.todo.Perf, alt = { "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = icons.todo.Note, color = "hint", alt = { "INFO" } },
                TEST = { icon = icons.todo.Test, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            colors = {
                error = { colors.diag.error },
                warning = { colors.diag.warn },
                info = { colors.diag.info },
                hint = { colors.diag.hint },
                default = { colors.syntax.keyword },
                test = { colors.palette.pink.bright }
            }
        })

        vim.keymap.set("n", "gtn", function() require("todo-comments").jump_next() end, { desc = "Next Todo Comment " })
        vim.keymap.set("n", "gtp", function() require("todo-comments").jump_prev() end,
            { desc = "Previous Todo Comment " })
        vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Search for TODO comments" })
    end
}
