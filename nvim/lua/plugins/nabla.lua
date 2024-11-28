return {
    'jbyuki/nabla.nvim',
    config = function ()
        local nabla = require('nabla')
        vim.keymap.set('n', '<leader>np', function ()
            nabla.popup()
        end) 
    end,
}

