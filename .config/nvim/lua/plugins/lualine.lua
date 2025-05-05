return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      theme = 'auto', -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
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
          show_filename_only = false,
          hide_filename_extension = false,
          show_modified_status = true,
          mode = 0,
          buffers_color = {
            active = 'lualine_a_normal',
            inactive = 'gray',
          },
        },
      },
      lualine_b = {{'diagnostics', sources = {'nvim_diagnostic'}}},
      lualine_c = {'diff', 'navic'},

      lualine_x = {'lsp_status'},
      lualine_y = {'progress', 'location'},
      lualine_z = {'selectioncount', 'searchcount'}
    }
  }
}
