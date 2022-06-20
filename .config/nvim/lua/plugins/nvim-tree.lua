require'nvim-tree'.setup {
  filters = {
    dotfiles = false,
  },
  view = {
    preserve_window_proportions = true,
    mappings = {
      list = {
        { key = "s", action = "vsplit" },
        { key = "i", action = "split" },
      },
    },
  },
}
