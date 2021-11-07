-- vim: foldlevel=99:
local status, lspcolors = pcall(require, "lsp-colors")
if (not status) then return end


-- Setting LSP colors to the NightFox color theme
local nightfox;
status, nightfox = pcall(require, "nightfox.colors")
if status then
  local c = nightfox.init();
  lspcolors.setup({
    Error = c.red,
    Warning = c.orange,
    Information = c.cyan_dm,
    Hint = c.green_dm
  })
end
