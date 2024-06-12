return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "bash", "dockerfile", "go", "graphql", "json", "lua", "make", "ruby", "yaml", "hcl", "terraform" },
      highlight = {
        enable = true,
        use_langtree = true,
      },
      rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
      },
      indent = {
        enable = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          scope_incremental = '<CR>',
          node_incremental = '<TAB>',
          node_decremental = '<S-TAB>',
        },
      },
    }
  end,
}
