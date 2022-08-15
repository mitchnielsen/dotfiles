vim.api.nvim_create_autocmd("VimResized", {
  pattern = '*',   
  command = 'tabdo wincmd = | lua require("fzf-lua").redraw()'
})
