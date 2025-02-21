---@type LazyPluginSpec
return {
  'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
  event = 'BufReadPre',
  dependencies = {
    'williamboman/mason.nvim', -- https://github.com/williamboman/mason.nvim
    'b0o/schemastore.nvim', -- https://github.com/b0o/schemastore.nvim
    { 'j-hui/fidget.nvim', opts = {} }, -- https://github.com/j-hui/fidget.nvim
  },
  config = function()
    local lspconfig = require('lspconfig')
    local configure_server = require('lsp').configure_server
    require('lspconfig.ui.windows').default_options.border = 'rounded'

    configure_server('cssls', {
      settings = {
        validate = true,
        lint = { unknownAtRules = 'ignore' },
      },
    })

    configure_server('vtsls', {
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'svelte' },
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = 'always' },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = 'literals' },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    })

    configure_server('jsonls', {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    configure_server('lua_ls', {
      settings = {
        Lua = {
          format = { enable = false },
          diagnostics = {
            globals = { 'vim' },
            disable = { 'missing-fields' },
          },
          telemetry = { enable = false },
          hint = { enable = true, arrayIndex = 'Disable' },
        },
      },
    })

    configure_server('taplo', {
      settings = {
        taplo = {
          configFile = { enabled = true },
          schema = {
            enabled = true,
            catalogs = { 'https://www.schemastore.org/api/json/catalog.json' },
            cache = { memoryExpiration = 60, diskExpiration = 600 },
          },
        },
      },
    })

    configure_server('yamlls', {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = '' },
          scehmas = require('schemastore').yaml.schemas(),
        },
      },
    })

    configure_server('zls', {
      root_dir = lspconfig.util.root_pattern('.git', 'build.zig', 'zls.json'),
      settings = {
        zls = {
          enable_inlay_hints = true,
          enable_snippets = true,
          warn_style = true,
        },
      },
    })

    configure_server('eslint', { settings = { format = false } })
    configure_server('docker_compose_language_service')
    configure_server('dockerls')
    configure_server('html')
    configure_server('hyprls')
    configure_server('marksman')
    configure_server('ocamllsp', { cmd_end = { DUNE_BUILD_DIR = '_build_lsp' } })
    configure_server('pyright')
    configure_server('protols')
    configure_server('svelte')
  end,
}
