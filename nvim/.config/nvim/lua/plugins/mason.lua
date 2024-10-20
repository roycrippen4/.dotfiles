---@type LazyPluginSpec
return {
  'williamboman/mason.nvim', -- https://github.com/williamboman/mason.nvim
  keys = {
    { '<leader>m', '<cmd> Mason <cr>' },
  },
  cmd = 'Mason',
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
}
