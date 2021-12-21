local lsp_installer = require('nvim-lsp-installer')

require('lsp-status').register_progress()

local on_init = function(client)
  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  require('lsp-status').on_attach(client)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  mappings = {
    f = {
      name = 'Find',
      d = { '<cmd>Lspsaga lsp_finder<cr>', 'Find definitions' },
      D = { ':Telescope lsp_definitions<cr>', 'Find definitions (Telescope)' },
      r = { '<cmd>Lspsaga lsp_finder<cr>', 'Find references' },
      R = { ':Telescope lsp_references<cr>', 'Find references (Telescope)' },
    },
    l = {
      name = 'LSP',
      a = { ':Lspsaga code_actions<cr>', 'Show available code actions' },
      A = { ':Telescope lsp_code_actions<cr>', 'Show available code actions (Telescope)' },
      d = { ':Lspsaga lsp_finder<cr>', 'Find definition' },
      D = { ':Telescope lsp_definitions<cr>', 'Find definition (Telescope)' },
      f = { '<cmd>Format<CR>', 'Format buffer' },
      i = { '<cmd>Lspsaga implement<CR>', 'Find implementation' },
      I = { '<cmd>Telescope lsp_implementations<CR>', 'Find implementation (Telescope)' },
      n = { ':Lspsaga rename<cr>', 'Rename symbol' },
      r = { ':Lspsaga lsp_finder<cr>', 'Find references' },
      R = { ':Telescope lsp_references<cr>', 'Find references (Telescope)' },
      s = { ':Lspsaga signature_help<cr>', 'Signature help' },
    },
    x = {
      name = 'Inspections',
      d = { ':Trouble document_diagnostics<cr>', 'Document diagnostics' },
      l = { ':Trouble loclist<cr>', 'Open diagnostics in loclist' },
      q = { ':Trouble quickfix<cr>', 'Open diagnostics in quickfix list' },
      w = { ':Trouble workspace_diagnostics<cr>', 'Workspace diagnostics' },
      x = { ':TroubleToggle<cr>', 'Toggle diagnostics' },
    },
  }

  require('which-key').register(
    mappings,
    { prefix = '<leader>', buffer = bufnr, mode = 'n', noremap = true, silent = true }
  )

  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', '<C-r><C-r>', ':Lspsaga rename<cr>', opts)
  buf_set_keymap('n', 'K', ':Lspsaga hover_doc<cr>', opts)

  buf_set_keymap('n', '<S-C-j>', ':Lspsaga diagnostic_jump_next<cr>', opts)
  buf_set_keymap('n', '<M-End>', ':Lspsaga diagnostic_jump_next<cr>', opts)
  buf_set_keymap('n', '<S-M-Right>', ':Lspsaga diagnostic_jump_next<cr>', opts)
  buf_set_keymap('n', '<S-C-k>', ':Lspsaga diagnostic_jump_prev<cr>', opts)
  buf_set_keymap('n', '<M-Home>', ':Lspsaga diagnostic_jump_prev<cr>', opts)
  buf_set_keymap('n', '<S-M-Left>', ':Lspsaga diagnostic_jump_prev<cr>', opts)

  -- automatic formatting on save
  if client.resolved_capabilities.document_formatting then
    vim.cmd([[augroup Format]])
    vim.cmd([[autocmd!]])
    vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]])
    vim.cmd([[augroup END]])
  end

  --protocol.SymbolKind = { }
  local icons = {
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
    kinds[i] = icons[kind] or kind
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
capabilities.textDocument.codeAction.dynamicRegistration = true
capabilities = vim.tbl_extend('keep', capabilities, require('lsp-status').capabilities)

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

-- vim: foldlevel=99:
