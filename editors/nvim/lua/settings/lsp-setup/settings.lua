local installed, lsp_setup = pcall(require, 'nvim-lsp-setup')
if not installed then
  return
end

local mappings = require('magicmonty.mappings')

require('mason').setup({
  ui = {
    border = 'rounded',
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
    keymaps = {
      toggle_package_expand = '<CR>',
      install_package = 'i',
      update_package = 'u',
      check_package_version = 'c',
      update_all_packages = 'U',
      check_outdated_packages = 'C',
      uninstall_package = 'X',
      cancel_installation = '<C-c>',
      apply_language_filter = '<C-f>',
    },
  },
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'sumneko_lua',
    'ltex',
    'json',
    'solargraph',
  },
})

local on_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true

  local has_sonicpi, sonicpi = pcall(require, 'sonicpi')
  if has_sonicpi then
    sonicpi.lsp_on_init(client, { server_dir = '/opt/sonic-pi/app/server' })
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  --Enable completion triggered by <c-x><c-o>
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Mappings.
  local leader_mappings = {
    l = {
      name = 'LSP',
      f = { '<cmd>Format<cr>', 'Format buffer' },
      n = { vim.lsp.buf.rename, 'Rename symbol' },
    },
    d = {
      name = 'Diagnostics',
      l = { '<cmd>Telescope diagnostics<CR>', 'Workspace diagnostics list' },
      n = { vim.diagnostic.goto_next, 'Jump to next diagnostic entry' },
      p = { vim.diagnostic.goto_prev, 'Jump to previous diagnostic entry' },
    },
  }

  if client.server_capabilities.codeActionProvider then
    leader_mappings.l.a = { vim.lsp.buf.code_action, 'Show available code actions' }
  end

  mappings.register(leader_mappings, { prefix = '<leader>', buffer = bufnr, mode = 'n', noremap = true, silent = true })

  local normal_mappings = {
    ['<C-s>'] = { vim.lsp.buf.signature_help, 'Show signature help' },
    g = {
      name = 'Goto',
      d = { '<cmd>Telescope lsp_definitions<CR>', 'Goto definition' },
      D = { vim.lsp.buf.declaration, 'Goto declaration' },
      i = { '<cmd>Telescope lsp_implementations<CR>', 'Goto implementation' },
      r = { '<cmd>Telescope lsp_references<CR>', 'Goto reference' },
      T = { '<cmd>Telescope lsp_type_definitions<CR>', 'Goto type definition' },
    },
    K = { vim.lsp.buf.hover, 'Show hover documentation' },
  }

  mappings.register(normal_mappings, { buffer = bufnr, mode = 'n', noremap = true, silent = true })

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

  if client.server_capabilities.documentHighlightProvider then
    local augroup_highlight = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
    vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_highlight })
    vim.api.nvim_create_autocmd('CursorHold', {
      group = augroup_highlight,
      buffer = 0,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = augroup_highlight,
      buffer = 0,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client.server_capabilities.codeLensProvider then
    local augroup_code_lens = vim.api.nvim_create_augroup('lsp_document_code_lens', { clear = true })
    vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_code_lens })
    vim.api.nvim_create_autocmd('BufEnter', {
      group = augroup_code_lens,
      buffer = 0,
      once = true,
      callback = vim.lsp.codelens.refresh,
    })
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'CursorHold' }, {
      group = augroup_code_lens,
      buffer = 0,
      callback = vim.lsp.codelens.refresh,
    })
  end

  if client.server_capabilities.documentFormattingProvider then
    local augroup_format = vim.api.nvim_create_augroup('lsp_format', { clear = true })
    vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup_format })
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = 0,
      callback = vim.lsp.buf.formatting_sync,
    })
  end
end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.codeLens = { dynamicRegistration = false }
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

lsp_setup.setup({
  default_mappings = false,
  capabilities = capabilities,
  on_attach = on_attach,
  on_init = on_init,
  mappings = {},
  servers = {
    sumneko_lua = require('lua-dev').setup({
      library = {
        vimruntime = true,
        types = true,
        plugins = true,
      },
      runtime_path = false,
      lspconfig = {
        settings = {
          Lua = {
            format = { enable = true },
            diagnostics = { globals = { 'use' } },
          },
        },
      },
    }),
    ltex = {
      settings = {
        ltex = {
          additionalRules = {
            motherTongue = 'de-DE',
          },
          language = 'de-DE',
        },
      },
    },
    jsonls = {
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
    },
    solargraph = {
      single_file_support = true,
      filetypes = { 'ruby', 'sonicpi' },
      cmd = {
        '/home/mgondermann/.local/share/gem/ruby/3.0.0/bin/solargraph',
        'stdio',
      },
      cmd_env = {
        GEM_HOME = '/home/mgondermann/.local/share/gem/ruby/3.0.0',
        GEM_PATH = '/home/mgondermann/.local/share/gem/ruby/3.0.0',
      },
      settings = {
        solargraph = {
          autoformat = true,
          diagnostics = true,
          formatting = true,
        },
      },
      pylsp = {
        single_file_support = true,
      },
    },
  },
})

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
