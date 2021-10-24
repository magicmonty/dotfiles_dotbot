-- vim: foldlevel=99:
local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local protocol = require'vim.lsp.protocol'
local augroup = require("vim_ext").augroup

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
  capabilities = capabilities,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
}

-- Lua support
local sumneko_root_path =  vim.fn.fnamemodify(vim.fn.exepath("terminal"), ":h:h") .. "/src/lua-language-server"
local sumneko_binary =  sumneko_root_path .. "/bin/Linux/lua-language-server"
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = runtime_path
      },
      diagnostics = {
        -- get the server to recognize the vim global
        globals = { "vim" }
      },
      workspace = {
        -- make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true)
      },
      -- do not send telemetry data
      telemetry = {
        enable = false
      }
    }
  }
}

-- C# support
local pid = vim.fn.getpid()
local omnisharp_bin = "/usr/bin/omnisharp"

nvim_lsp.omnisharp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) };
  filetypes = { "cs" }
}

-- Clojure support
nvim_lsp.clojure_lsp.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

