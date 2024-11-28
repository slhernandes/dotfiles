return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- "nvim-telescope/telescope.nvim",
  },
  config = function()
    -- old harpoon config
    -- local mark = require("harpoon.mark")
    -- local ui = require("harpoon.ui")

    -- vim.keymap.set("n", "<leader>a", mark.add_file)
    -- vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

    -- vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
    -- vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
    -- vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
    -- vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)

    local harpoon = require("harpoon")
    harpoon:setup()

    -- basic telescope configuration
    -- local conf = require("telescope.config").values
    -- local function toggle_telescope(harpoon_files)
    --   local file_paths = {}
    --   for _, item in ipairs(harpoon_files.items) do
    --     table.insert(file_paths, item.value)
    --   end

    --   require("telescope.pickers").new({}, {
    --     prompt_title = "Harpoon",
    --     finder = require("telescope.finders").new_table({
    --       results = file_paths,
    --     }),
    --     previewer = conf.file_previewer({}),
    --     sorter = conf.generic_sorter({}),
    --   }):find()
    -- end
    -- REQUIRED

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = '[h]arpoon [a]dd' })
    vim.keymap.set("n", "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[h]arpoon [e]dit' })
    -- vim.keymap.set("n", "<A-e>", function()
    --   toggle_telescope(harpoon:list())
    -- end,
    -- { desc = "Open harpoon window" })

    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<A-p>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<A-n>", function() harpoon:list():next() end)
  end,
}
