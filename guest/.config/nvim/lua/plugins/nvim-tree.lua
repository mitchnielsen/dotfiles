require'nvim-tree'.setup {
  filters = {
    dotfiles = true,
  },
  view = {
    preserve_window_proportions = false,
    mappings = {
      list = {
        { key = "s", action = "vsplit" },
        { key = "i", action = "split" },
      },
    },
  },
}
