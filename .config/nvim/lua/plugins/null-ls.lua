require("null-ls").setup({
    sources = {
        require("null-ls").builtins.completion.spell,
        require("null-ls").builtins.diagnostics.golangci_lint,
    },
    defaults = {
      on_attach = {
        vim.diagnostic.config({
          virtual_text = false,
        }),
      },
    },
})
