return {
  {
    "3rd/image.nvim",
    ft= {"norg", "md", "py", "ipynb", "qmd", "jpeg", "jpg", "png"},
    -- luarocks config in neorg.lua
    dependencies = { "luarocks.nvim" },
    config = function()

      local function file_exists(name)
        local f = io.open(name, "r")
        if f ~= nil then
          io.close(f)
          return true
        else
          return false
        end
      end

      local function generateImage(document_path, image_path, fallback)
        -- document_path is the path to the file that contains the image
        -- image_path is the potentially relative path to the image. for
        -- markdown it's `![](this text)`
        local digest = require("openssl.digest")

        local function hashString(input)
          local sha256 = digest.new("sha256")
          sha256:update(input)
          local hash = sha256:final()
          return hash
        end

        -- Convert hash to a hexadecimal string for readability
        local function toHexString(hash)
          return (hash:gsub(".", function(c)
            return string.format("%02x", string.byte(c))
          end))
        end

        local t = {}
        for str in string.gmatch(image_path, "([^;]+)") do
          table.insert(t, str)
        end

        -- you can call the fallback function to get the default behavior
        if t[1] == "data:image/png" then

          local ltn12 = require "ltn12"
          local mime = require "mime"

          local temp = {}
          for str in string.gmatch(image_path, "([^,]+)") do
            table.insert(temp, str)
          end

          local out_file = "/tmp/" .. string.sub(toHexString(hashString(temp[2])), 1, 20) .. ".png"

          if not file_exists(out_file) then
            ltn12.pump.all(ltn12.source.string(temp[2]),ltn12.sink.chain(mime.decode("base64"),ltn12.sink.file(io.open(out_file,"w"))))
          end

          return out_file

        else
          return fallback(document_path, image_path)
        end
      end

      -- default config
      require("image").setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            filetypes = { "markdown", "vimwiki", "ipynb" }, -- markdown extensions (ie. quarto) can go here
            resolve_image_path = generateImage,
          },
          neorg = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = true,
            filetypes = { "norg" },
            resolve_image_path = generateImage,
          },
          html = {
            enabled = false,
          },
          css = {
            enabled = false,
          },
        },
        max_width = 100,
        max_height = 12,
        max_width_window_percentage = math.huge,
        max_height_window_percentage = math.huge,
        window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
      })
    end
  }
}
