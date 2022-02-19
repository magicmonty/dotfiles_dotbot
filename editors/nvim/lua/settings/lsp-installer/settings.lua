local lsp_installer = require('nvim-lsp-installer')

local status = require('settings.lsp-status.settings')
status.activate()

local on_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  require('lsp-status').on_attach(client)
  --Enable completion triggered by <c-x><c-o>
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- Mappings.
  local leader_mappings = {
    l = {
      name = 'LSP',
      a = { vim.lsp.buf.code_action, 'Show available code actions' },
      f = { '<cmd>Format<cr>', 'Format buffer' },
      n = { vim.lsp.buf.rename, 'Rename symbol' },
    },
    d = {
      name = 'Diagnostics',
      l = { '<cmd>Telescope diagnostics<cr>', 'Workspace diagnostics list' },
      n = { vim.diagnostic.goto_next, 'Jump to next diagnostic entry' },
      p = { vim.diagnostic.goto_prev, 'Jump to previous diagnostic entry' },
    },
  }

  local wk = require('which-key')
  wk.register(leader_mappings, { prefix = '<leader>', buffer = bufnr, mode = 'n', noremap = true, silent = true })

  local normal_mappings = {
    ['<C-s>'] = { vim.lsp.buf.signature_help, 'Show signature help' },
    g = {
      name = 'Goto',
      d = { '<cmd>Telescope lsp_definitions<cr>', 'Goto definition' },
      D = { vim.lsp.buf.declaration, 'Goto declaration' },
      r = { '<cmd>Telescope lsp_references<cr>', 'Goto reference' },
      i = { '<cmd>Telescope lsp_implementations<cr>', 'Goto implementation' },
      T = { '<cmd>Telescope lsp_type_definitions<cr>', 'Goto type definition' },
    },
    K = { vim.lsp.buf.hover, 'Show hover documentation' },
  }

  wk.register(normal_mappings, { buffer = bufnr, mode = 'n', noremap = true, silent = true })

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

  if client.resolved_capabilities.document_highlight then
    vim.cmd([[
      augroup lsp_document_highlight
        au! * <buffer>
        au CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        au CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end

  if client.resolved_capabilities.code_lens then
    vim.cmd([[
      augroup lsp_document_code_lens
        au! * <buffer>
        au BufEnter ++once lua vim.lsp.codelens.refresh()
        au BufWritePost,CursorHold <buffer> lua vim.lsp.codelens.refresh()
      augroup END
    ]])
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
capabilities = vim.tbl_deep_extend('keep', capabilities, require('lsp-status').capabilities)
capabilities.textDocument.codeLens = { dynamicRegistration = false }
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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

  if server.name == 'ltex' then
    opts.settings = {
      ltex = {
        additionalRules = {
          motherTongue = 'de-DE',
        },
        language = 'de-DE',
      },
    }
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
