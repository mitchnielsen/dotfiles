return {
  {
    -- Editor helpers
    'tpope/vim-commentary',
    'tpope/vim-unimpaired', --Simple mappings
    'takac/vim-commandcaps', -- takes care of caps typos
    'tiagovla/scope.nvim', config = true,
    'stevearc/dressing.nvim', -- improve vim.ui interfaces
    {
      "iamcco/markdown-preview.nvim", -- markdown preview plugin for (neo)vim
      build = function() vim.fn["mkdp#util#install"]() end, -- install without yarn or npm
    },

    -- ... and any others in lua/plugins/*.lua
  }
}
