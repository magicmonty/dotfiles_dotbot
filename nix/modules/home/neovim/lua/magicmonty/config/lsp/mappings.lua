local M = {}

M.set_mappings = function(client, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true })
  end

  local telescope = require('telescope.builtin')

  nmap('<leader>dl', telescope.diagnostics, 'Workspace [d]iagnostics list')
  nmap('<leader>dn', require('lspsaga.diagnostic').goto_next, 'Jump to next diagnostics entry')
  nmap('<leader>dp', require('lspsaga.diagnostic').goto_prev, 'Jump to previous diagnostics entry')
  nmap('<leader>o', function() vim.cmd.Lspsaga('outline') end, 'Toggle Outline')

  if client.server_capabilities.codeActionProvider then
    nmap('<leader>ca', function() vim.cmd.Lspsaga('code_action') end, 'Code Action')
  end

  nmap('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gd', function() vim.cmd.Lspsaga('goto_definition') end, 'Goto Definition')
  nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
  nmap('gi', function() vim.cmd.Lspsaga('lsp_finder') end, 'Goto Implementation')
  nmap('gr', function() vim.cmd.Lspsaga('lsp_finder') end, 'Goto References')
  nmap('gT', function() vim.cmd.Lspsaga('lsp_type_definitions') end, 'Goto Type definition')

  nmap('<leader>cs', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
  nmap('<leader>cS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

  nmap('K', function() vim.cmd.Lspsaga('hover_doc') end, 'Hover Documentation')

  local inc_rename_installed, inc_rename = pcall(require, 'inc_rename')
  if inc_rename_installed then
    inc_rename.setup()

    vim.keymap.set("n", "<leader>rr", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })
    vim.keymap.set("n", "<leader>cn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })
  else
    nmap('<leader>cn', function() vim.cmd.Lspsaga("rename") end, 'Rename')
    nmap('<leader>rr', function() vim.cmd.Lspsaga("rename") end, 'Rename')
  end
end

M.setup_formatting = function(client, bufnr)
  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })

  vim.keymap.set('n', '<leader>f', vim.cmd.Format, { buffer = bufnr, desc = 'Format buffer', silent = true })
  vim.keymap.set('n', '<leader>cf', vim.cmd.Format, { buffer = bufnr, desc = 'Format buffer', silent = true })

  -- Autoformat on save
  if client.server_capabilities.documentFormattingProvider then
    local augroup_format = Augroup('lsp_format', { clear = true })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup_format })
    Autocmd('BufWritePre', {
      buffer = bufnr,
      group = augroup_format,
      callback = function() vim.cmd.Format() end
    })
  end
end

return M
