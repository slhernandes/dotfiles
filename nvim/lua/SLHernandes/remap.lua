-- set mapleader as space
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- space p v as netrw hotkey
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- copy/paste to/from clipboard
vim.keymap.set("n", "<leader>yy", "\"+y")
vim.keymap.set("v", "<leader>yy", "\"+y")
vim.keymap.set("n", "<leader>pp", "\"+p")
vim.keymap.set("v", "<leader>pp", "\"+p")
-- move line up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- delete to null register
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
-- change indentation 
vim.keymap.set("v", "<leader><", "<Vgv")
vim.keymap.set("v", "<leader>>", ">Vgv")
vim.keymap.set("n", "<leader>fc", function ()
  local ft = vim.bo.filetype
  if ft == "c" or ft == "cpp" then
    vim.cmd("%!clang-format")
  elseif ft == "rust" then
    vim.cmd("%!rustfmt")
  end
end)
-- tab hotkeys
vim.keymap.set("n", "<leader>tn", function() vim.cmd("tabn") end)
vim.keymap.set("n", "<leader>tp", function() vim.cmd("tabp") end)
vim.keymap.set("n", "<leader>tc", function() vim.cmd("tabc") end)
-- buffer hotkeys
vim.keymap.set("n", "<leader>bn", function() vim.cmd("bn") end)
vim.keymap.set("n", "<leader>bp", function() vim.cmd("bp") end)
vim.keymap.set("n", "<leader>bc", function() vim.cmd("bd") end)
-- quickfix hotkeys
vim.keymap.set("n", "<leader>cc", function() vim.cmd("cc") end)
vim.keymap.set("n", "<leader>cn", function() vim.cmd("cn") end)
vim.keymap.set("n", "<leader>cp", function() vim.cmd("cp") end)
-- alt + [wasd] to resize to adjecent window 
vim.keymap.set("n", "<M-H>", "<C-w>5<")
vim.keymap.set("n", "<M-J>", "<C-w>-")
vim.keymap.set("n", "<M-K>", "<C-w>+")
vim.keymap.set("n", "<M-L>", "<C-w>5>")
-- alt + [hjkl] to move to adjecent window 
vim.keymap.set("n", "<M-h>", function ()
  if vim.fn.winnr() == vim.fn.winnr("h") then
    os.execute("tmux if -F '#{pane_at_left}' '' 'select-pane -L'")
  else
    vim.cmd("wincmd h")
  end
end)

vim.keymap.set("n", "<M-j>", function ()
  if vim.fn.winnr() == vim.fn.winnr("j") then
    os.execute("tmux if -F '#{pane_at_bottom}' '' 'select-pane -D'")
  else
    vim.cmd("wincmd j")
  end
end)

vim.keymap.set("n", "<M-k>", function ()
  if vim.fn.winnr() == vim.fn.winnr("k") then
    os.execute("tmux if -F '#{pane_at_top}' '' 'select-pane -U'")
  else
    vim.cmd("wincmd k")
  end
end)

vim.keymap.set("n", "<M-l>", function ()
  if vim.fn.winnr() == vim.fn.winnr("l") then
    os.execute("tmux if -F '#{pane_at_right}' '' 'select-pane -R'")
  else
    vim.cmd("wincmd l")
  end
end)
