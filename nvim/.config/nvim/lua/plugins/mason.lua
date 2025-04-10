---@type LazyPluginSpec[]
return {
  {
    'williamboman/mason.nvim', -- https://github.com/williamboman/mason.nvim
    keys = {
      { '<leader>m', '<cmd> Mason <cr>' },
    },
    cmd = 'Mason',
    opts = {
      ui = {
        icons = { package_pending = ' ', package_installed = '󰄳 ', package_uninstalled = ' 󰚌' },
        keymaps = { toggle_help = '?' },
      },
      max_concurrent_installers = 10,
    },
    config = function(_, opts)
      require('mason').setup(opts)

      vim
        .iter({
          -- Language servers
          'clangd',
          'css-lsp',
          'docker-compose-language-service',
          'dockerfile-language-server',
          'eslint-lsp',
          'html-lsp',
          'hyprls',
          'json-lsp',
          'lua-language-server',
          'marksman',
          'pyright',
          'rust-analyzer',
          'svelte-language-server',
          'tailwindcss-language-server',
          'taplo',
          'vtsls',
          'yaml-language-server',

          -- Formatters
          'yamlfmt',
          'stylua',
          'prettierd',
          'prettier',
          'shfmt',

          -- debuggers
          'codelldb',
        })
        :filter(function(package)
          return not require('mason-registry').is_installed(package)
        end)
        :each(vim.cmd.MasonInstall)
    end,
  },
}
