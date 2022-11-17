require('lualine').setup({
  options = {
    theme = 'nord', -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
    component_separators = '-',
    section_separators = '',
    globalstatus = true,
  },
  sections = {},
  inactive_sections = {},
  tabline = {
    lualine_a = {
      {
        'buffers',
        show_filename_only = true,
        hide_filename_extension = false,
        show_modified_status = true,
        mode = 2,
        buffers_color = {
          active = 'lualine_a_normal',
          inactive = 'gray',
        },
      },
    },
    lualine_b = {{'diagnostics', sources = {'nvim_diagnostic'}}},
    lualine_c = {'diff'},

    lualine_x = {
      function()
        return require("lsp-status").status()
      end,
    },
    lualine_y = {'searchcount', 'progress', 'location'},
    lualine_z = {'branch'}
  }
})
