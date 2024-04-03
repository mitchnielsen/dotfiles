return {
  'mfussenegger/nvim-lint',
  event = 'BufWritePost', -- was LspAttach
  config = function()
    vim.diagnostic.config({virtual_text = false})

    local lint = require('lint')

    lint.linters_by_ft = {
      sh = {'shellcheck'},
      bash = {'shellcheck'},
      yaml = {'yamllint', 'golangcilint'},
      markdown = {'markdownlint', 'vale'},
      ruby = {'rubocop'},
      json = {'jsonlint'},
      python = {'pylint'},
    }

    lint.try_lint()

    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end
}
