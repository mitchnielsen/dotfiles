local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- LSP
  use("glepnir/lspsaga.nvim")
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
  use("simrat39/symbols-outline.nvim")
  use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons", })

  -- Theme
  use("EdenEast/nightfox.nvim")
  use("nvim-lualine/lualine.nvim")

  -- Editor helpers
  use { "ibhagwan/fzf-lua", requires = { "kyazdani42/nvim-web-devicons" } }
  use("editorconfig/editorconfig-vim")
  use("iamcco/markdown-preview.nvim")
  use("machakann/vim-highlightedyank") -- Highlight yanked line
  use("tpope/vim-commentary")
  use("tpope/vim-unimpaired") --Simple mappings
  use("takac/vim-commandcaps") -- takes care of caps typos
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("nvim-tree").setup({})
    end,
  })
  use("lukas-reineke/indent-blankline.nvim")

  -- git helpers
  use("kdheepak/lazygit.nvim")
  use("tpope/vim-fugitive") -- Git integration
  use("shumphrey/fugitive-gitlab.vim")
  use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim", }, })

  -- go helpers
  use("fatih/vim-go")
  use("vim-test/vim-test")

  -- Other helpers
  use("ChartaDev/charta.vim") -- learn new codebases and share explanations
  use("ojroques/vim-oscyank") -- ability to yank to clipboard in VM
  use("nathom/filetype.nvim") -- speed up load time
end)
