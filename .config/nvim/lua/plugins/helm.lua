return {
  'mrjosh/helm-ls',
  dependencies = {
    'towolf/vim-helm',
  },
  config = function()
    -- curl -L https://github.com/mrjosh/helm-ls/releases/download/master/helm_ls_{os}_{arch} --output /usr/local/bin/helm_ls
    local configs = require('lspconfig.configs')
    local lspconfig = require('lspconfig')
    local util = require('lspconfig.util')

    if not configs.helm_ls then
      configs.helm_ls = {
        default_config = {
          cmd = {"helm_ls", "serve"},
          filetypes = {'helm'},
          root_dir = function(fname)
            return util.root_pattern('Chart.yaml')(fname)
          end,
        },
      }
    end

    lspconfig.helm_ls.setup {
      filetypes = {"helm"},
      cmd = {"helm_ls", "serve"},
    }
  end
}
