return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set("n", "<leader>gs", function () 
      vim.cmd.Git()
      vim.cmd("wincmd L")
      vim.cmd("wincmd 45|")
    end)
  end,
}
