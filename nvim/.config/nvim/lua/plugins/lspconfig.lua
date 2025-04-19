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
    local configure_server = require('lsp').configure_server
    require('lspconfig.ui.windows').default_options.border = 'rounded'

    configure_server('cssls', {
      cmd = { 'bun', '--bun', 'run', 'vscode-css-language-server', '--stdio' },
      settings = {
        validate = true,
        lint = { unknownAtRules = 'ignore' },
      },
    })

    configure_server('clangd', {
      cmd = {
        'clangd',
        '--clang-tidy',
        '--header-insertion=iwyu',
        '--completion-style=detailed',
        '--fallback-style=none',
        '--function-arg-placeholders=false',
      },
    })

    configure_server('vtsls', {
      cmd = { 'bun', '--bun', 'run', 'vtsls', '--stdio' },
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
      cmd = { 'bun', '--bun', 'run', 'vscode-json-language-server', '--stdio' },
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
      cmd = { 'bun', '--bun', 'run', 'yaml-language-server', '--stdio' },
      settings = {
        yaml = {
          schemaStore = { enable = false, url = '' },
          scehmas = require('schemastore').yaml.schemas(),
        },
      },
    })

    configure_server('eslint', {
      cmd = { 'bun', '--bun', 'run', 'vscode-eslint-language-server', '--stdio' },
      settings = { format = false },
    })

    configure_server('hyprls')
    configure_server('marksman')
    configure_server('svelte')
    configure_server('html', { cmd = { 'bun', '--bun', 'run', 'vscode-html-language-server', '--stdio' } })
    configure_server('pyright', { cmd = { 'bun', '--bun', 'run', 'pyright-langserver', '--stdio' } })
    configure_server('docker_compose_language_service', { cmd = { 'bun', '--bun', 'run', 'docker-compose-langserver', '--stdio' } })
    configure_server('dockerls', { cmd = { 'bun', '--bun', 'run', 'docker-langserver', '--stdio' } })

    configure_server('ocamllsp', {
      cmd_env = { DUNE_BUILD_DIR = '_build_lsp' },
      settings = {
        codelens = { enable = true },
        inlayHints = { enable = true },
        syntaxDocumentation = { enable = true },
      },
    })

    configure_server('zls', {
      settings = {
        zls = { enable_snippets = false },
      },
    })

    -- TODO: Investigate the state of protobuf lsp.
    -- Seems like it's merged.
    -- https://github.com/bufbuild/buf/pull/3316
    -- configure_server('protols')
  end,
}
