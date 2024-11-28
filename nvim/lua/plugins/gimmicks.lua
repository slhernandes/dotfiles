return {
  {
    'eandrju/cellular-automaton.nvim',
    config = function ()
      vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
    end,
  },
  {
    'alanfortlink/blackjack.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function ()
      require("blackjack").setup({
        card_style = "mini", -- Can be "mini" or "large".
        suit_style = "black", -- Can be "black" or "white".
        scores_path = "/home/samuelhernandes/.local/share/blackjack/blackjack_scores.json", -- Default location to store the scores.json file.
        keybindings = {
          ["next"] = "j",
          ["finish"] = "k",
          ["quit"] = "q",
        },
      })
    end,
  },
  {
    'ThePrimeagen/vim-be-good'
  },
}
