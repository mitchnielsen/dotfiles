return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
  },
  keys = {
    { "<leader>g", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", desc = "live_grep" },
    { "<leader>f", "<cmd>Telescope find_files<CR>", desc = "files" },
    { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "grep buffers" },
    {"gr", "<cmd>Telescope lsp_references<CR>", desc = "references"},
    {"gi", "<cmd>Telescope lsp_implementations<CR>", desc = "implementation"},
    {"gd", "<cmd>Telescope lsp_definitions<CR>", desc = "definition"},
  },
  config = function()
    local actions = require('telescope.actions')
    local selected_qf = {
      ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
    }

    require('telescope').setup{
      defaults = {
        layout_config = {
          vertical = { width = 0.5 }
        },
        mappings = { -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
          i = selected_qf,
          n = selected_qf,
        }
      },
      pickers = {
        find_files = {
          theme = "ivy",
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          theme = "ivy",
          additional_args = function()
            return {"--hidden", "--glob", "!**/.git/*"}
          end
        },
      },
    }

    require("telescope").load_extension("live_grep_args")
  end
}
