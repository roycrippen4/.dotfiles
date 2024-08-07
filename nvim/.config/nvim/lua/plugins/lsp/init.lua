require('plugins.lsp.overrides')
local utils = require('core.utils')

vim.g.zig_fmt_parse_errors = 0

---@return boolean
local function has_tailwind_config()
  return utils.file_exists('tailwind.config.js') or utils.file_exists('tailwind.config.cjs') or utils.file_exists('tailwind.config.ts')
end

return {
  'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
  event = 'VimEnter',
  dependencies = {
    {
      'folke/neodev.nvim', -- https://github.com/folke/neodev.nvim,
      opts = {},
    },
    {
      'williamboman/mason.nvim', -- https://github.com/williamboman/mason.nvim
      cmd = 'Mason',
      lazy = false,
      opts = {
        ensure_installed = {
          'lua-language-server',
          'stylua',
          'css-lsp',
          'html-lsp',
          'json-language-server',
          'prettier',
          'prettierd',
          'rust-analyzer',
          'typescript-language-server',
          'clangd',
          'clang-format',
        },
        PATH = 'skip',
        ui = {
          icons = { package_pending = ' ', package_installed = '󰄳 ', package_uninstalled = ' 󰚌' },
          keymaps = {
            toggle_server_expand = '<CR>',
            install_server = 'i',
            update_server = 'u',
            check_server_version = 'c',
            update_all_servers = 'U',
            check_outdated_servers = 'C',
            uninstall_server = 'X',
            cancel_installation = '<C-c>',
            toggle_help = '?',
          },
        },
        max_concurrent_installers = 10,
      },
    },
    { 'j-hui/fidget.nvim', opts = {} },
    'b0o/schemastore.nvim',
  },
  config = function()
    local lspconfig = require('lspconfig')
    local M = require('plugins.lsp.lsp-utils')

    lspconfig['clangd'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['cssls'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['docker_compose_language_service'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['dockerls'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['eslint'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['gopls'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['hls'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['html'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['hyprls'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['jsonls'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    lspconfig['lua_ls'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
      settings = {
        Lua = {
          format = { enable = false },
          semantic = { enable = true },
          diagnostics = { globals = { 'vim' } },
          telemetry = { enable = false },
          hint = { enable = true, arrayIndex = 'Disable' },
          workspace = {
            library = { [vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    })

    lspconfig['marksman'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['pyright'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['svelte'].setup({
      capabilities = vim.tbl_deep_extend('force', M.capabilities, { workspace = { dynamicRegistration = true } }),
      on_attach = M.on_attach,
    })

    if has_tailwind_config() then
      lspconfig['tailwindcss'].setup({
        capabilities = M.capabilities,
        on_attach = M.on_attach,
      })
    end

    lspconfig['taplo'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })

    lspconfig['yamlls'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
      settings = {
        yaml = {
          schemaStore = { enable = false, url = '' },
          scehmas = require('schemastore').yaml.schemas(),
        },
      },
    })

    lspconfig['zls'].setup({
      capabilities = M.capabilities,
      on_attach = M.on_attach,
    })
  end,
}
