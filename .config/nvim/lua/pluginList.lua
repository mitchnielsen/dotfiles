local cmd = vim.cmd

cmd("packadd packer.nvim")

local present, packer = pcall(require, "packer")

if not present then
  local packer_path = vim.fn.stdpath("data")
    .. "/site/pack/packer/opt/packer.nvim"

  print("Cloning packer..")
  -- remove the dir before cloning
  vim.fn.delete(packer_path, "rf")
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    "--depth",
    "20",
    packer_path,
  })

  cmd("packadd packer.nvim")
  present, packer = pcall(require, "packer")

  if present then
    print("Packer cloned successfully.")
  else
    error(
      "Couldn't clone packer !\nPacker path: " .. packer_path .. "\n" .. packer
    )
  end
end

packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "single" })
    end,
    prompt_border = "single",
  },
  git = {
    clone_timeout = 600, -- Timeout, in seconds, for git clones
  },
  auto_clean = true,
  compile_on_sync = true,
  --    auto_reload_compiled = true
})

require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- LSP
  use("glepnir/lspsaga.nvim")
  use("nvim-treesitter/nvim-treesitter")
  use("hrsh7th/nvim-compe")
  use("neovim/nvim-lspconfig")
  use("ray-x/lsp_signature.nvim")
  use({ "creativenull/diagnosticls-nvim", opt = true })

  -- Theme
  use("nvim-lualine/lualine.nvim")
  use("morhetz/gruvbox")

  -- Helpers
  use("junegunn/fzf")
  use("junegunn/fzf.vim")
  use("fatih/vim-go")
  use("tpope/vim-fugitive") -- Git integration
  use("shumphrey/fugitive-gitlab.vim")
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
  use("romgrk/nvim-treesitter-context")
end)
