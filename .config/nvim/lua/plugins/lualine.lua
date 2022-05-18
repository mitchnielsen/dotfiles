require('lualine').setup({
  options = {
    theme = 'auto', -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
    component_separators = '|',
    section_separators = '',
    -- globalstatus = true,
  },
  sections = {
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
    lualine_b = {
      {
        'filename',
        file_status = true, -- display file status (readonly, modified)
        path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
        shorting_target = 40 -- shorten path to leave space in window
      }
    },
    lualine_c = {'progress', 'location'},

    lualine_x = {{'diagnostics', sources = {'nvim_diagnostic'}}},
    lualine_y = {'encoding', 'fileformat', 'filetype'},
    lualine_z = {'branch'}
  }
})
