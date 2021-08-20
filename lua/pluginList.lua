require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- LSP
  use("glepnir/lspsaga.nvim")
  use("kabouzeid/nvim-lspinstall")
  use("nvim-treesitter/nvim-treesitter")
  use("hrsh7th/nvim-compe")
  use("neovim/nvim-lspconfig")
  use("ray-x/lsp_signature.nvim")
  use({ "creativenull/diagnosticls-nvim", opt = true })

  -- Theme
  use("itchyny/lightline.vim")
  use("rakr/vim-one")
  use("morhetz/gruvbox")

  -- Helpers
  use("junegunn/fzf")
  use("junegunn/fzf.vim")
  use("fatih/vim-go")
  use("tpope/vim-fugitive") -- Git integration
  use("shumphrey/fugitive-gitlab.vim")
  use("machakann/vim-highlightedyank") -- Highlight yanked line
  use("unblevable/quick-scope") -- Quick jump in line
  use("editorconfig/editorconfig-vim")
  use("scrooloose/nerdtree")
  use("Xuyuanp/nerdtree-git-plugin")
  use("ryanoasis/vim-devicons")
  use("wakatime/vim-wakatime") -- Send data to Wakatime
  use("tpope/vim-unimpaired") --Simple mappings
  use("takac/vim-commandcaps") -- takes care of caps typos
  use("ChartaDev/charta.vim") -- learn new codebases and share explanations
  use("iamcco/markdown-preview.nvim")
  use("phaazon/hop.nvim")
  use("simrat39/symbols-outline.nvim")
  use("tpope/vim-commentary")
  use("jiangmiao/auto-pairs")
  use({ "folke/lua-dev.nvim", opt = true })
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  })
  use({
    "lewis6991/gitsigns.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })
end)
