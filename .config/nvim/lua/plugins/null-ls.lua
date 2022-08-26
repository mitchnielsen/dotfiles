local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.vale,
        null_ls.builtins.diagnostics.yamllint,
    },
    defaults = {
      on_attach = {
        vim.diagnostic.config({
          virtual_text = false,
        }),
      },
    },
})
