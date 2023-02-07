return {
  'nvim-telescope/telescope.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  keys = {
    { "<leader>g", "<cmd>Telescope live_grep<CR>", desc = "live_grep" },
    { "<leader>f", "<cmd>Telescope find_files<CR>", desc = "files" },
    { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "grep buffers" },
    {"gr", "<cmd>Telescope lsp_references<CR>", desc = "references"},
    {"gi", "<cmd>Telescope lsp_implementations<CR>", desc = "implementation"},
    {"gd", "<cmd>Telescope lsp_definitions<CR>", desc = "definition"},
  },
  opts = {
    defaults = {
      layout_config = {
        vertical = { width = 0.5 }
      },
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
}
