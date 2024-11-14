---@type LazyPluginSpec[]
return {
  {
    'williamboman/mason.nvim', -- https://github.com/williamboman/mason.nvim
    keys = {
      { '<leader>m', '<cmd> Mason <cr>' },
    },
    cmd = 'Mason',
    opts = {
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
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim', -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    lazy = false,
    opts = {
      ensure_installed = {
        'black',
        'clang-format',
        'clangd',
        'codelldb',
        'css-lsp',
        'docker-compose-language-service',
        'dockerfile-language-server',
        'eslint-lsp',
        'gopls',
        'html-lsp',
        'htmx-lsp',
        'hyprls',
        'js-debug-adapter',
        'json-lsp',
        'lua-language-server',
        'marksman',
        'prettier',
        'prettierd',
        'pyright',
        'rust-analyzer',
        'shfmt',
        'stylua',
        'svelte-language-server',
        'tailwindcss-language-server',
        'taplo',
        'typescript-language-server',
        'yaml-language-server',
        'yamlfmt',
        -- 'zls',
      },
    },
  },
}
