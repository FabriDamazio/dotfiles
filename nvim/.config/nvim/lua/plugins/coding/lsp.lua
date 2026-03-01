return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    
    local capabilities = cmp_lsp.default_capabilities()

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "expert",
        "omnisharp",
      },
      automatic_installation = true,
    })

    vim.lsp.config['expert'] = {
      cmd = { "expert", "--stdio" },
      filetypes = { 'elixir', 'heex' },
      root_markers = { 'mix.exs', '.git' },
      capabilities = capabilities,
    }

    vim.lsp.config['lua_ls'] = {
      cmd = { "lua-language-server" },
      filetypes = { 'lua' },
      root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = "Lua 5.1" },
          diagnostics = {
            globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        }
      }
    }

    vim.lsp.config['rust_analyzer'] = {
      cmd = { "rust-analyzer" },
      filetypes = { 'rust' },
      root_markers = { 'Cargo.toml', '.git' },
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true
          },
          check = {
            command = "clippy",
            extraArgs = { "--no-deps" }
          },
          procMacro = {
            enable = true
          }
        }
      }
    }

    vim.lsp.config['omnisharp'] = {
      cmd = { "omnisharp" },
      filetypes = { 'cs', 'vb' },
      root_markers = { '*.sln', '*.csproj', '.git' },
      capabilities = capabilities,
      settings = {
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
      }
    }

    vim.lsp.enable('expert')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('rust_analyzer')
    vim.lsp.enable('omnisharp')

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
      }),
    })

    vim.diagnostic.config({
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end
}
