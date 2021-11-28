local status, lsp_installer = pcall(require, 'nvim-lsp-installer')
if not status then
  return
end

local lsp_status = require('lsp-status')
lsp_status.register_progress()

local on_init = function(client)
  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  lsp_status.on_attach(client)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<leader>ca', ':lua require("telescope.builtin").lsp_code_actions()<cr>', opts)
  buf_set_keymap('n', '<leader>gr', ":lua require('telescope.builtin').lsp_references()<cr>", opts)
  buf_set_keymap('n', '<leader>gd', ":lua require('telescope.builtin').lsp_definitions()<cr>", opts)
  buf_set_keymap('n', '<leader>gi', ":lua require('telescope.builtin').lsp_implementations()<cr>", opts)

  buf_set_keymap('n', '<leader>wa', ':lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
  buf_set_keymap('n', '<leader>wr', ':lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
  buf_set_keymap('n', '<leader>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', opts)

  buf_set_keymap('n', '<leader>D', ':lua vim.lsp.buf.type_definition()<cr>', opts)

  buf_set_keymap('n', '<S-C-j>', ':lua vim.lsp.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap('n', '<S-C-k>', ':lua vim.lsp.diagnostic.goto_prev()<cr>', opts)

  buf_set_keymap('n', '<leader>f', ':Format<cr>', opts)

  -- automatic formatting on save
  if client.resolved_capabilities.document_formatting then
    vim.cmd([[augroup Format]])
    vim.cmd([[autocmd!]])
    vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]])
    vim.cmd([[augroup END]])
  end

  --protocol.SymbolKind = { }
  local M = {}
  M.icons = {
    Text = ' Text',
    Method = ' Method',
    Function = ' Function',
    Constructor = ' Constructor',
    Field = ' Field',
    Variable = ' Variable',
    Class = ' Class',
    Interface = 'I Interface',
    Module = ' Module',
    Property = ' Property',
    Unit = ' Unit',
    Value = ' Value',
    Enum = ' Enum',
    Keyword = ' Keyword',
    Snippet = '﬌ Snippet',
    Color = ' Color',
    File = ' File',
    Reference = ' Reference',
    Folder = ' Folder',
    EnumMember = ' EnumMember',
    Constant = ' Constant',
    Struct = ' Struct',
    Event = ' Event',
    Operator = 'ﬦ Operator',
    TypeParameter = ' TypeParameter',
  }

  local kinds = vim.lsp.protocol.CompletionItemKind
  for i, kind in ipairs(kinds) do
    kinds[i] = M.icons[kind] or kind
  end
end

lsp_installer.settings({
  ui = {
    icons = {
      server_installed = '✓',
      server_pending = '➜',
      server_uninstalled = '✗',
    },
  },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local hascmp, cmp = pcall(require, 'cmp_nvim_lsp')
if hascmp then
  capabilities = cmp.update_capabilities(capabilities)
end

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}
capabilities.textDocument.codeAction = {
  dynamicRegistration = true,
}
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }

  if server.name == 'pylsp' then
    opts.single_file_support = true
  end

  if server.name == 'sumneko_lua' then
    local luadev = require('lua-dev').setup({
      library = {
        vimruntime = true,
        types = true,
        plugins = true,
      },
      lspconfig = {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { 'use' } },
            workspace = { preloadFileSize = 350 },
            telemetry = { enable = false },
          },
        },
      },
    })

    local plugin_path = vim.fn.stdpath('data') .. '/plugged'
    for _, p in pairs(vim.fn.expand(plugin_path .. '/*/lua', false, true)) do
      p = vim.loop.fs_realpath(p)
      if p then
        table.insert(luadev.settings.Lua.runtime.path, p .. '/?.lua')
        table.insert(luadev.settings.Lua.runtime.path, p .. '/?/init.lua')
      end
    end

    luadev.settings.Lua.workspace.library[vim.fn.expand(plugin_path .. '/lua/cmp/types')] = true

    server:setup(luadev)
    return
  end

  if server.name == 'jsonls' then
    opts.commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
        end,
      },
    }
    opts.settings = {
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
    }
  end

  server:setup(opts)
end)

-- LSP signs default
vim.fn.sign_define(
  'DiagnosticSignError',
  { texthl = 'DiagnosticSignError', text = '', numhl = 'DiagnosticSignError' }
)
vim.fn.sign_define('DiagnosticSignWarn', { texthl = 'DiagnosticSignWarn', text = '', numhl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignHint', { texthl = 'DiagnosticSignHint', text = '', numhl = 'DiagnosticSignHint' })
vim.fn.sign_define(
  'DiagnosticSignInfo',
  { texthl = 'DiagnosticSignInfo', text = '', numhl = 'DiagnosticSignInformation' }
)

-- LSP Enable diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    prefix = '»',
    severity_limit = 'Warning',
    spacing = 4,
  },
  underline = true,
  signs = true,
  update_in_insert = false,
})

local pop_opts = { border = 'rounded', max_width = 80 }
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, pop_opts)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, pop_opts)

vim.cmd([[command! -nargs=0 LspVirtualTextToggle lua require'lsp.virtual_text'.toggle()]])

-- vim: foldlevel=99:
