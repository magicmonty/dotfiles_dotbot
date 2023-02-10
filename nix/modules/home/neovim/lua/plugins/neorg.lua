return {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    opts = {
        load = {
            ["core.defaults"] = {}, -- Loads default behaviour
            ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
            ["core.norg.dirman"] = { -- Manages Neorg workspaces
                config = {
                    default_workspace = "notes",
                    workspaces = {
                        notes = "~/notes",
                    },
                },
            },
            ["core.norg.completion"] = {
                config = {
                    engine = "nvim-cmp"
                }
            }
        },
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
}
