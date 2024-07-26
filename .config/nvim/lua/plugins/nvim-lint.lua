return {
  'mfussenegger/nvim-lint',
  event = 'LspAttach',
  config = function()
    vim.diagnostic.config({
      focus = false,
      virtual_text = false,
      signs = true,
      severity_sort = true,
      float = {
        header = 'Diagnostics',
        source = true,
        border = 'rounded',
        format = function(diagnostic)
          if diagnostic.user_data and diagnostic.user_data.code then
            return string.format('%s %s', diagnostic.user_data.code, diagnostic.message)
          else
            return diagnostic.message
          end
        end,
      },
    })

    local lint = require('lint')

    lint.linters_by_ft = {
      sh = {'shellcheck'},
      bash = {'shellcheck'},
      yaml = {'yamllint', 'actionlint'},
      markdown = {'markdownlint', 'vale'},
      ruby = {'rubocop'},
      json = {'jsonlint'},
      python = {'ruff'},
      terraform = {'tflint'},
      go = {'golangcilint'},
    }

    lint.try_lint()

    vim.api.nvim_create_autocmd("BufWritePost", {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end
}
