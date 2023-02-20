if string.find(vim.loop.os_uname().release, 'microsoft') then
  vim.g.clipboard = {
    name = 'WSLClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'pwsh.exe -NoProfile -NonInteractive -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'pwsh.exe -NoProfile -NonInteractive -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = false
  }
end
