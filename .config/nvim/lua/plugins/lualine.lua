require('lualine').setup({
  options = {
    theme = 'auto', -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
    component_separators = '|',
    section_separators = '',
    -- globalstatus = true,
  },
  sections = {},
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
          inactive = 'lualine_a_inactive',
        },
      },
    },
    lualine_b = {},
    lualine_c = {},

    lualine_x = {{'diagnostics', sources = {'nvim_diagnostic'}}},
    lualine_y = {'filetype'},
    lualine_y = {'progress', 'location'},
    lualine_z = {'branch'}
  }
})
