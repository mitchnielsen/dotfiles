local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- LSP
  use("nvim-treesitter/nvim-treesitter")
  use("nvim-treesitter/nvim-treesitter-context")
  use("p00f/nvim-ts-rainbow")
  use("neovim/nvim-lspconfig")
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-vsnip")
  use("hrsh7th/vim-vsnip")
  use("ray-x/lsp_signature.nvim")
  use("jose-elias-alvarez/null-ls.nvim")
  use("nvim-lua/lsp-status.nvim")
  use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" })

  -- Theme
  use("nvim-lualine/lualine.nvim")
  use("RRethy/nvim-base16")
  use("norcalli/nvim-colorizer.lua")

  -- Editor helpers
  use { "ibhagwan/fzf-lua", requires = "kyazdani42/nvim-web-devicons" }
  use("tpope/vim-commentary")
  use("tpope/vim-unimpaired") --Simple mappings
  use("takac/vim-commandcaps") -- takes care of caps typos
  use({ "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" })
  use("tiagovla/scope.nvim")
  use("preservim/vim-markdown")

  -- git helpers
  use("tpope/vim-fugitive") -- Git integration
  use("shumphrey/fugitive-gitlab.vim")
  use({ "lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim" })

  -- go helpers
  use("ray-x/go.nvim")
  use("vim-test/vim-test")

  -- tmux helpers
  use("preservim/vimux")
end)
