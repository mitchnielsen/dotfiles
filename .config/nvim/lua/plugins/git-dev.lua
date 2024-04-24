-- Shallow clone a repository and open it in Neovim.
-- Easy way to navigate repositories locally instead of
-- in the browser.
return {
  'moyiz/git-dev.nvim',
  event = 'VeryLazy',
  opts = {
    cd_type = "tab",
    opener = function(dir)
      vim.cmd "tabnew"
      vim.cmd("NvimTreeOpen " .. vim.fn.fnameescape(dir))
    end
  },
  keys = {
    {
      "<leader>o",
      function()
        local repo = vim.fn.input "Repository name / URI: "
        if repo ~= "" then
          require("git-dev").open(repo)
        end
      end,
      desc = "[O]pen a remote git repository",
    }
  }
}
