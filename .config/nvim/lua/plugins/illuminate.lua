return {
  'RRethy/vim-illuminate',
  config = function()
    require('illuminate').configure({
      min_count_to_highlight = 2,
      delay = 500,
    })

    vim.api.nvim_set_hl(0, 'IlluminatedWordText', { fg="black", bg="gray" })
    vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { fg="black", bg="gray" })
    vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { fg="black", bg="gray" })
  end
}
