local M = {}

M.opts = {
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.lin('$'), 0 })
      end,
    },
  },
  settings = {
    json = {
      schemaDownload = { enable = true },
      schemas = {
        {
          description = 'JSON schema for Babel 6+ configuration files',
          fileMatch = { '.babelrc' },
          url = 'https://json.schemastore.org/babelrc.json',
        },
        {
          description = 'ESLint config',
          fileMatch = { '.eslintrc.json', '.eslintrc' },
          url = 'https://json.schemastore.org/eslintrc.json',
        },
        {
          description = 'Prettier config',
          fileMatch = {
            '.prettierrc',
            '.prettierrc.json',
            'prettier.config.json',
          },
          url = 'https://json.schemastore.org/prettierrc.json',
        },
        {
          description = 'TypeScript compiler configuration file',
          fileMatch = { 'tsconfig.json', 'tsconfig.*.json' },
          url = 'https://json.schemastore.org/tsconfig.json',
        },
        {
          description = 'NPM package config',
          fileMatch = { 'package.json' },
          url = 'https://json.schemastore.org/package.json',
        },
        {
          description = 'A JSON schema for ASP.net launchsettings.json files',
          fileMatch = { 'launchsettings.json' },
          url = 'https://json.schemastore.org/launchsettings.json',
        },
        {
          description = 'VSCode snippets',
          fileMatch = { '**/snippets/*.json' },
          url = 'https://raw.githubusercontent.com/Yash-Singh1/vscode-snippets-json-schema/main/schema.json',
        },
      },
    },
  },
}

return M
