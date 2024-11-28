return {
  "folke/zen-mode.nvim",
  lazy = true,
  config = function ()
    require("zen-mode").toggle({
      window = {
        width = .85 -- width will be 85% of the editor width
      }
    })
  end,
}
