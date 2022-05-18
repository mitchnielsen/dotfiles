require'nvim-treesitter.configs'.setup {
 ensure_installed = { "bash", "dockerfile", "go", "graphql", "json", "lua", "make", "ruby", "yaml" },
  highlight = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  },
}
