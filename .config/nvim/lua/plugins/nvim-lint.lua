return {
  'mfussenegger/nvim-lint',
  event = 'BufWritePost', -- was LspAttach
  config = function()
    vim.diagnostic.config({virtual_text = true})

    local lint = require('lint')

    lint.linters_by_ft = {
      sh = {'shellcheck'},
      bash = {'shellcheck'},
      yaml = {'yamlllint', 'golangcilint'},
      markdown = {'markdownlint', 'vale'},
      ruby = {'rubocop'},
      json = {'jsonlint'},
    }

    lint.try_lint()
  end
}
