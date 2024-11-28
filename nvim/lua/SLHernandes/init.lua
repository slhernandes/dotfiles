require("SLHernandes.remap")
require("SLHernandes.set")
vim.api.nvim_exec([[
  autocmd BufNewFile 1*.cpp 0r ~/.config/nvim/templates/template.cpp
  ]],
  false
)
vim.api.nvim_exec([[
  autocmd BufNewFile aoc*.rs 0r ~/.config/nvim/templates/template.rs
  ]],
  false
)
vim.api.nvim_exec([[
  autocmd BufNewFile *.cc 0r ~/.config/nvim/templates/opp_template.cc
  ]],
  false
)
vim.api.nvim_exec([[
  autocmd BufNewFile *.ned 0r ~/.config/nvim/templates/opp_template.ned
  ]],
  false
)
vim.api.nvim_exec([[
  autocmd BufNewFile *.ini 0r ~/.config/nvim/templates/opp_template.ini
  ]],
  false
)
vim.api.nvim_exec([[
 set rtp^="/home/samuelhernandes/.opam/default/share/ocp-indent/vim"
 ]],
 false
)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- change the configuration when editing a python file
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.py",
  callback = function(e)
    if string.match(e.file, ".otter.") then
      return
    end
    if require("molten.status").initialized() == "Molten" then -- this is kinda a hack...
      vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
    else
      vim.g.molten_virt_lines_off_by_1 = false
    end
  end,
})

-- Undo those config changes when we go back to a markdown or quarto file
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.qmd", "*.md", "*.ipynb" },
  callback = function(e)
    if string.match(e.file, ".otter.") then
      return
    end
    if require("molten.status").initialized() == "Molten" then
      vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
    else
      vim.g.molten_virt_lines_off_by_1 = true
    end
  end,
})

-- Hyprlang LSP
--vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
--		pattern = {"*.hl", "hypr*.conf"},
--		callback = function(event)
--				print(string.format("starting hyprls for %s", vim.inspect(event)))
--				vim.lsp.start {
--						name = "hyprlang",
--						cmd = {"hyprls"},
--						root_dir = vim.fn.getcwd(),
--				}
--		end
--})
