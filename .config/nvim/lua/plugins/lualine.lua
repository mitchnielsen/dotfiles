return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "kyazdani42/nvim-tree.lua",
  },
  opts = {},
  config = function()
    local nvim_tree_shift = {
      function()
        local winnr = require("nvim-tree.view").get_winnr()
        if not winnr then
          return ""
        end
        local len = vim.api.nvim_win_get_width(winnr) - 1
        local title = "Nvim-Tree"
        local left = (len - #title) / 2
        local right = len - left - #title

        return string.rep(" ", left) .. title .. string.rep(" ", right)
      end,
      cond = require("nvim-tree.view").is_visible,
      color = "Normal",
    }

    require("lualine").setup({
      options = {
        theme = "auto", -- https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
        component_separators = "-",
        section_separators = "",
        globalstatus = false,
      },
      sections = {},
      inactive_sections = {},
      tabline = {
        lualine_a = {
          nvim_tree_shift,
          {
            "tabs",
            mode = 0,
          },
          {
            "buffers",
            show_filename_only = false,
            hide_filename_extension = false,
            show_modified_status = true,
            mode = 0,
            use_mode_colors = false,
          },
        },
        lualine_b = { { "diagnostics", sources = { "nvim_diagnostic" } } },
        lualine_c = { "diff", "navic" },

        lualine_x = { "lsp_status" },
        lualine_y = { "progress", "location" },
        lualine_z = { "selectioncount", "searchcount" },
      },
      extensions = {
        "nvim-tree",
        "lazy",
        "fzf",
      },
    })
  end,
}
