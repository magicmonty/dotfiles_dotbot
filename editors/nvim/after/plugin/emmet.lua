local status, emmet = pcall(require, 'ext.emmet')
if not status then
  return
end

emmet.setup({})
