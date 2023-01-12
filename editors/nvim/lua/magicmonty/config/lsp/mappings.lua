local M = {}

M.set_mappings = function(client, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true })
  end

  local telescope = require('telescope.builtin')
  nmap('<leader>ln', function() vim.cmd.Lspsaga("rename") end, '[L]sp re[n]ame')

  nmap('<leader>dl', telescope.diagnostics, 'Workspace [d]iagnostics [l]ist')
  nmap('<leader>dn', require('lspsaga.diagnostic').goto_next, 'Jump to [n]ext [d]iagnostics entry')
  nmap('<leader>dp', require('lspsaga.diagnostic').goto_prev, 'Jump to [p]revious [d]iagnostics entry')
  nmap('<leader>o', function() vim.cmd.Lspsaga('outline') end, 'Toggle [O]utline')

  if client.server_capabilities.codeActionProvider then
    nmap('<leader>la', function() vim.cmd.Lspsaga('code_action') end, '[C]ode [A]ction')
  end

  nmap('<C-s>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gd', function() vim.cmd.Lspsaga('lsp_finder') end, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gi', function() vim.cmd.Lspsaga('lsp_finder') end, '[G]oto [I]mplementation')
  nmap('gr', function() vim.cmd.Lspsaga('lsp_finder') end, '[G]oto [R]eferences')
  nmap('gT', function() vim.cmd.Lspsaga('lsp_type_definitions') end, '[G]oto [T]ype definition')

  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('K', function() vim.cmd.Lspsaga('hover_doc') end, 'Hover Documentation')
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

  vim.keymap.set('n', '<leader>f', vim.cmd.Format, { buffer = bufnr, desc = '[F]ormat buffer', silent = true })
  vim.keymap.set('n', '<leader>lf', vim.cmd.Format, { buffer = bufnr, desc = '[F]ormat buffer', silent = true })

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
