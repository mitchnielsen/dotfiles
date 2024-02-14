return {
  'RRethy/vim-illuminate',
  config = function()
    vim.api.nvim_set_hl(0, 'IlluminatedWordText', { fg="black", bg="gray" })
    vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { fg="red", bg="green" })
    vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { fg="red", bg="green" })
  end
}
