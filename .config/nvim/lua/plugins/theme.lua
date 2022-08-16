vim.o.background = "dark" -- or "light" for light mode

require('base16-colorscheme').setup({
  -- Override base00 to pure black
  base00 = '#000000', base01 = '#2c313c', base02 = '#3e4451', base03 = '#6c7891',
  base04 = '#565c64', base05 = '#abb2bf', base06 = '#9a9bb3', base07 = '#c5c8e6',
  base08 = '#e06c75', base09 = '#d19a66', base0A = '#e5c07b', base0B = '#98c379',
  base0C = '#56b6c2', base0D = '#0184bc', base0E = '#c678dd', base0F = '#a06949',
})

require'colorizer'.setup() -- show colors over color codes

-- https://github.com/alacritty/alacritty/issues/109#issuecomment-440353106
-- https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/
-- if exists('+termguicolors')
--   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
--   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
-- endif
