-- LaTeX
return {
  'lervag/vimtex',
  ft = { 'tex' },
  config = function()
    vim.g.tex_flavor = 'latex'
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_compiler_latexmk = {
      build_dir = './out',
      options = {
        '-pdf',
        '-interaction=nonstopmode',
        '-synctex=1',
        '-outdir=./out',
        '-shell-escape'
      }
    }
  end
}
