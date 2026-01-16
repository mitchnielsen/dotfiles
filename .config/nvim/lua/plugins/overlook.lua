return {
  "WilliamHsieh/overlook.nvim",
  opts = {},

  keys = {
    {
      "<leader>gd",
      function()
        require("overlook.api").peek_definition()
      end,
      desc = "Overlook: Peek definition",
    },
    {
      "<leader>gc",
      function()
        require("overlook.api").close_all()
      end,
      desc = "Overlook: Close all popup",
    },
    {
      "<leader>gu",
      function()
        require("overlook.api").restore_popup()
      end,
      desc = "Overlook: Restore popup",
    },
  },
}
