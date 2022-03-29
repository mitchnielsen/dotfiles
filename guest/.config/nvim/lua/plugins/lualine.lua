local vim = vim
vim.o.termguicolors = true

require('lualine').setup({
  options = {
    theme = 'auto', -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
    component_separators = { left = '|', right = '|' },
    globalstatus = true,
  },
  sections = {
    lualine_a = {'branch'},
    lualine_b = {{'diagnostics', sources = {'nvim_diagnostic'}}},
    lualine_c = {
      {
        'filename',
        file_status = true, -- displays file status (readonly, modified)
        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
        shorting_target = 40, -- shorten path to leave space in window
      }
    },
    lualine_x = {'filetype'}
  }
})
