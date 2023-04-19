return {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    opts = {
        load = {
            ["core.defaults"] = {},  -- Loads default behaviour
            ["core.concealer"] = {}, -- Adds pretty icons to your documents
            ["core.dirman"] = {      -- Manages Neorg workspaces
                config = {
                    default_workspace = "notes",
                    workspaces = {
                        notes = "~/notes",
                    },
                },
            },
            ["core.completion"] = {
                config = {
                    engine = "nvim-cmp"
                }
            }
        },
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
}
