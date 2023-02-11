-- REST client
return {
    'NTBBloodbath/rest.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    opts = {
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = true,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = true,
        -- Highlight request on run
        highlight = {
            enabled = true,
            timeout = 150,
        },
        result = {
            -- toggle showing URL, HTTP info, headers at top the of result window
            show_url = true,
            show_http_info = true,
            show_headers = true,
        },
        -- Jump to request line on run
        jump_to_request = true,
        env_file = '.env',
        custom_dynamic_variables = {},
        yank_dry_run = true,
    }
}
