-- vim: foldlevel=99:
local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local on_init = function(client)
  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', ':lua vim.lsp.buf.declaration()<cr>', opts)
  buf_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', opts)
  buf_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<cr>', opts)
  buf_set_keymap('n', '<leader>wa', ':lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
  buf_set_keymap('n', '<leader>wr', ':lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
  buf_set_keymap('n', '<leader>wl', ':lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', opts)
  buf_set_keymap('n', '<leader>D', ':lua vim.lsp.buf.type_definition()<cr>', opts)
  buf_set_keymap('n', '<leader>rn', ':lua vim.lsp.buf.rename()<cr>', opts)
  buf_set_keymap('n', '<leader>ca', ':lua require("telescope.builtin").lsp_code_actions()<cr>', opts)
  buf_set_keymap('n', 'gr', ':lua require("telescope.builtin").lsp_references()<cr>', opts)
  buf_set_keymap('n', '<leader>e', ':lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', opts)
  buf_set_keymap('n', '<S-C-j>', ':lua vim.lsp.diagnostic.goto_next()<cr>', opts)
  buf_set_keymap('n', '<leader>q', ':lua require("telescope.builtin").lsp_document_diagnostics()<cr>', opts)
  buf_set_keymap("n", "<leader>f", ":lua vim.lsp.buf.formatting()<cr>", opts)

  -- automatic formatting on save
  if client.resolved_capabilities.document_formatting then
    vim.cmd [[augroup Format]]
    vim.cmd [[autocmd!]]
    vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.cmd [[augroup END]]
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

-- Adds UltiSnips support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits'
  }
}

local hascmp,cmp = pcall(require, "cmp_nvim_lsp")
if hascmp then
  capabilities = cmp.update_capabilities(capabilities)
end

-- Typescript support
nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
}

-- Python support
nvim_lsp.pylsp.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "python" },
  single_file_support = true
}

-- Lua support
local sumneko_root_path =  vim.fn.fnamemodify(vim.fn.exepath("terminal"), ":h:h") .. "/src/lua-language-server"
local sumneko_binary =  sumneko_root_path .. "/bin/Linux/lua-language-server"

local luadev = require("lua-dev").setup({
  library = {
    vimruntime = true,
    types = true,
    plugins = true
  },
  lspconfig = {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    settings = {
      Lua = {
        diagnostics = {
          globals = {"use"}
        },
        workspace = {
          preloadFileSize = 350
        },
        telemetry = {
          enable = false
        }
      }
    }
  }
})

nvim_lsp.sumneko_lua.setup(luadev)

-- C# support
local pid = vim.fn.getpid()
local omnisharp_bin = "/usr/bin/omnisharp"

nvim_lsp.omnisharp.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) };
  filetypes = { "cs" }
}

-- Clojure support
nvim_lsp.clojure_lsp.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities
}

-- Emmet support
local configs = require('lspconfig/configs')
if not nvim_lsp.ls_emmet then
  configs.ls_emmet = {
    default_config = {
      cmd = { "ls_emmet", "--stdio" },
      filetypes = { "html", "css", "scss" },
      root_dir =  function(_)
        return vim.loop.cwd()
      end,
      settings = {},
    }
  }
end

local emmet_capabilities = vim.lsp.protocol.make_client_capabilities()
emmet_capabilities.textDocument.completion.completionItem.snippetSupport = true
nvim_lsp.ls_emmet.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = emmet_capabilities
}

-- Angular support
nvim_lsp.angularls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

-- JSON with schema support
nvim_lsp.jsonls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
      end
    }
  },
  schemas = {
    {
      filematch = { ".vimspector.json" },
      url = "https://puremourning.github.io/vimspector/schema/vimspector.schema.json"
    }
  }
}

-- LSP signs default
vim.fn.sign_define(
  "DiagnosticSignError",
  { texthl = "DiagnosticSignError", text = "", numhl = "DiagnosticSignError" }
)
vim.fn.sign_define(
  "DiagnosticSignWarn",
  { texthl = "DiagnosticSignWarn", text = "", numhl = "DiagnosticSignWarn" }
)
vim.fn.sign_define(
  "DiagnosticSignHint",
  { texthl = "DiagnosticSignHint", text = "", numhl = "DiagnosticSignHint" }
)
vim.fn.sign_define(
  "DiagnosticSignInfo",
  { texthl = "DiagnosticSignInfo", text = "", numhl = "DiagnosticSignInformation" }
)

-- LSP Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    virtual_text = {
      prefix = "»",
      severity_limit = 'Warning',
      spacing = 4
    },
    underline = true,
    signs = true,
    update_in_insert = false,
  }
)

local pop_opts = { border = "rounded", max_width = 80 }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, pop_opts)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, pop_opts)

