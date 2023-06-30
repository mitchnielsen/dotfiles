return {
  'tzachar/highlight-undo.nvim',
  lazy = false,
  opts = {
    hlgroup = 'HighlightUndo',
    duration = 300,
    keymaps = {
      {'n', 'u', 'undo', {}},
      {'n', '<C-r>', 'redo', {}},
    }
  }
}
