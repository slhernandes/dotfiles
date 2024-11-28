return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    {'neovim/nvim-lspconfig'},
    {'williamboman/mason.nvim'},
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-calc'},
    {'L3MON4D3/LuaSnip'},
    {'onsails/lspkind.nvim'},
  },
  config = function()

    for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
      local default_diagnostic_handler = vim.lsp.handlers[method]
      vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
          return
        end
        return default_diagnostic_handler(err, result, context, config)
      end
    end

    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'clangd',
        'pylsp',
        'texlab',
      },
    })

    vim.o.pumheight = 15
    local cmp = require('cmp')
    local lspkind = require('lspkind')
    cmp.setup({
      snippet = {
        expand = function (args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-p>'] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}),
        ['<C-n>'] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp'   },
        { name = 'luasnip'    },
        { name = 'otter'      },
        { name = 'buffer'     },
        { name = 'path'       },
        { name = 'treesitter' },
        { name = 'calc'       },
      }),
      formatting = {
        fields = { 'kind', 'abbr' },
        format = lspkind.cmp_format({
          mode = 'symbol', -- show only symbol annotations
          maxwidth = 20, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = '…', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = false, -- show labelDetails in menu. Disabled by default
          before = function (_, vim_item)
            vim_item.menu = ""
            return vim_item
          end,
        }),
        --format = function(entry, vim_item)
          --  local kind = lspkind.cmp_format({
            --    mode = 'symbol', -- show only symbol annotations
            --    maxwidth = 20, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            --    ellipsis_char = '…', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            --    show_labelDetails = false, -- show labelDetails in menu. Disabled by default
            --    --before = function () return vim_item end,
            --  })
            --  return kind
            --end,
          }
        })

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lsp_attach = function(client, bufnr)
          local opts = {buffer = bufnr, remap = false}

          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
          vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
          vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
          vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
          vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
          vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
          vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end

        local lspconfig = require('lspconfig')

        local _border = "single"
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = _border })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = _border })
        vim.diagnostic.config{ float={border=_border} }
        require('lspconfig.ui.windows').default_options = { border = _border }

        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          on_attach = lsp_attach,
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT'
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME
                }
              }
            })
          end,
          settings = {
            Lua = {}
          }
        })

        lspconfig.clangd.setup({
          capabilities = capabilities,
          on_attach = lsp_attach,
        })

        lspconfig.texlab.setup({
          capabilities = capabilities,
          on_attach = lsp_attach,
        })

        lspconfig.rust_analyzer.setup({
          capabilities = capabilities,
          on_attach = lsp_attach,
        })

        lspconfig.pylsp.setup({
          capabilities = capabilities,
          on_attach = lsp_attach,
          settings = {
            pylsp = {
              plugins = {
                jedi_completion = {
                  include_class_objects = true,
                  include_function_objects = true,
                  eager = true,
                }
              }
            }
          }
        })

        lspconfig.hyprls.setup({
          capabilities = capabilities,
          on_attach = lsp_attach,
        })

      end,
    }
