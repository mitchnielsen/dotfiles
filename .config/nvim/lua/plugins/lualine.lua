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

      lualine_x = {
        function()
          return require("lsp-status").status()
        end,
      },
      lualine_y = {'searchcount', 'progress', 'location'},
      lualine_z = {
        function()
          local filetype = vim.bo.filetype
          local linters = require("lint").linters_by_ft[filetype]

          if linters then
            return "linters:" .. filetype .. ": " .. table.concat(linters, ", ")
          else
            return "linters: " .. filetype .. "none"
          end
        end
      }
    }
  }
}
