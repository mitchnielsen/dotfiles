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
  use("hrsh7th/nvim-compe")
  use("neovim/nvim-lspconfig")
  use("ray-x/lsp_signature.nvim")
  use({ "creativenull/diagnosticls-nvim", opt = true })
  use("jose-elias-alvarez/null-ls.nvim")

  -- Theme
  use("navarasu/onedark.nvim")
  use("nvim-lualine/lualine.nvim")

  -- Helpers
  use { "ibhagwan/fzf-lua", requires = { "kyazdani42/nvim-web-devicons" } }
  use("vim-test/vim-test")
  use("fatih/vim-go")
  use("tpope/vim-fugitive") -- Git integration
  use("shumphrey/fugitive-gitlab.vim")
  use("kdheepak/lazygit.nvim")
  use("machakann/vim-highlightedyank") -- Highlight yanked line
  use("editorconfig/editorconfig-vim")
  use("scrooloose/nerdtree")
  use("Xuyuanp/nerdtree-git-plugin")
  use("ryanoasis/vim-devicons")
  use("tpope/vim-unimpaired") --Simple mappings
  use("takac/vim-commandcaps") -- takes care of caps typos
  use("ChartaDev/charta.vim") -- learn new codebases and share explanations
  use("iamcco/markdown-preview.nvim")
  use("simrat39/symbols-outline.nvim")
  use("tpope/vim-commentary")
  use({ "folke/lua-dev.nvim", opt = true })
  use({ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons", })
  use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim", }, })
  use("romgrk/nvim-treesitter-context")
  use("ojroques/vim-oscyank") -- ability to yank to clipboard in VM
  use("nathom/filetype.nvim") -- speed up load time
end)
