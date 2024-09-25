return {
  'ray-x/go.nvim',
  config = function ()
    require('go').setup({
      lsp_inlay_hints = {
        enable = true,
        style = 'eol',
      },
    })
  end,
  ft = {
    "go",
    "gomod",
    "gowork",
    "gotmpl",
  }
}
