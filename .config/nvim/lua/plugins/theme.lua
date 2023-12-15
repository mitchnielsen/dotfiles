return {
  'EdenEast/nightfox.nvim',
  name = 'nightfox',
  priority = 1000,
  lazy = false,
  config = function()
    require("nightfox").setup({
      options = {
        transparent = false,
      }
    })

    -- setup must be called before loading
    vim.cmd.colorscheme "nordfox"
  end
}
