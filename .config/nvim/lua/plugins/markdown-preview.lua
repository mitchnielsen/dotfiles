return {
  'iamcco/markdown-preview.nvim',
  build = function() vim.fn["mkdp#util#install"]() end, -- install without yarn or npm
  ft = "markdown",
}
