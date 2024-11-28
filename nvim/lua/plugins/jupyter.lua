return {
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    dependencies =  { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = function ()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_image_popup = true
      vim.g.molten_open_cmd = "xdg-open"
      vim.g.molten_output_show_more = true
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true



      -- keybindings
      vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
      { silent = true, desc = "Initialize the plugin" })
      vim.keymap.set("n", "<localleader>re", ":MoltenEvaluateOperator<CR>",
      { silent = true, desc = "run operator selection" })
      vim.keymap.set("n", "<localleader>rl", ":MoltenEvaluateLine<CR>",
      { silent = true, desc = "evaluate line" })
      vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>",
      { silent = true, desc = "re-evaluate cell" })
      vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
      { silent = true, desc = "evaluate visual selection" })
      vim.keymap.set("n", "<localleader>ro", ":noautocmd MoltenEnterOutput<CR>",
      { silent = true, desc = "show/enter output" })
      vim.keymap.set("n", "<localleader>rh", ":MoltenHideOutput<CR>",
      { desc = "close output window", silent = true })
      vim.keymap.set("n", "<localleader>rm", ":MoltenDelete<CR>",
      { desc = "delete Molten cell", silent = true })
    end,
  },
  {
    'quarto-dev/quarto-nvim',
    dependencies = {
      'jmbuhr/otter.nvim',
      'hrsh7th/nvim-cmp',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter'
    },
    ft = { 'quarto', 'markdown' },
    config = function ()
      local quarto = require("quarto")
      quarto.setup({
        lspFeatures = {
          -- NOTE: put whatever languages you want here:
          languages = { "python" },
          chunks = "all",
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
          },
          completion = {
            enabled = true,
          },
        },
        codeRunner = {
          enabled = true,
          default_method = "molten",
          ft_runners = { python = "molten" }, -- filetype to runner, ie. `{ python = "molten" }`.
        },
      })
      local runner = require("quarto.runner")
      vim.keymap.set("n", "<localleader>rc", runner.run_cell,  { desc = "run cell", silent = true })
      vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
      vim.keymap.set("n", "<localleader>rA", runner.run_all,   { desc = "run all cells", silent = true })
      vim.keymap.set("n", "<localleader>rl", runner.run_line,  { desc = "run line", silent = true })
      vim.keymap.set("v", "<localleader>r",  runner.run_range, { desc = "run visual range", silent = true })
      vim.keymap.set("n", "<localleader>RA", function()
        runner.run_all(true)
      end, { desc = "run all cells of all languages", silent = true })
    end
  },
  { -- directly open ipynb files as quarto docuements
    -- and convert back behind the scenes
    'GCBallesteros/jupytext.nvim',
    config = function()
      require("jupytext").setup({
        style = "markdown",
        output_extension = "md",
        force_ft = "markdown",
      })
    end,
  }
}
