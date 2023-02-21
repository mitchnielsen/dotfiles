return {
  'jose-elias-alvarez/null-ls.nvim',
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.vale,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.code_actions.gitsigns,
      },
      defaults = {
        on_attach = {
          vim.diagnostic.config({
            virtual_text = false,
          }),
        },
      },
    })
  end
}
