return {
  'nvim-telescope/telescope.nvim', version = '0.1.5',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function ()
    local icons = require("nvim-nonicons")
    require("telescope").setup({
      defaults = {
        prompt_prefix = "  " .. icons.get("telescope") .. "  ",
        selection_caret = " ❯ ",
        entry_prefix = "   ",
      },
    })
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)
    vim.keymap.set('n', '<leader>pl', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})   
  end,
}
