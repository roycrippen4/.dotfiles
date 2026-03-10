---@type LazyPluginSpec
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,
  config = function()
    vim.filetype.add({
      extension = {
        -- json = 'jsonc',
        cts = 'typescript',
        es6 = 'javascript',
        gif = 'image',
        jpeg = 'image',
        jpg = 'image',
        mli = 'ocamlinterface',
        mts = 'typescript',
        png = 'image',
        postcss = 'css',
        rasi = 'rasi',
        rofi = 'rasi',
        sh = 'sh',
        wofi = 'rasi',
        zsh = 'sh',
      },
      filename = {
        ['.fishenv'] = 'fish',
        ['.babelrc'] = 'json',
        ['.eslintrc'] = 'json',
        ['.prettierrc'] = 'json',
        ['.stylelintrc'] = 'json',
        ['sxhkdrc'] = 'sxhkdrc',
        ['.zshrc'] = 'sh',
        ['.zshenv'] = 'sh',
        -- ['bun.lock'] = 'jsonc',
        ['Caddyfile'] = 'caddy',
      },
      pattern = {
        ['d?o?c?k?e?r?%-?compose%.ya?ml'] = 'yaml.docker-compose',
        ['.*config/git/config'] = 'gitconfig',
        ['todo%.txt'] = 'todotxt',
        -- ['.*/waybar/config'] = 'jsonc',
        ['.*/kitty/.+%.conf'] = 'kitty',
        ['.*/hypr/.+%.conf'] = 'hyprlang',
        ['%.env%.[%w_.-]+'] = 'sh',
      },
    })

    vim.treesitter.language.register('bash', 'kitty')
    local filetypes = {
      'bash',
      'c',
      'comment',
      'cpp',
      'css',
      'dockerfile',
      'fish',
      'git_config',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'go',
      'html',
      'hyprlang',
      'java',
      'javascript',
      'jsdoc',
      'json',
      'lua',
      'luadoc',
      'luap',
      'markdown',
      'markdown_inline',
      'ocaml',
      'ocaml_interface',
      'python',
      'query',
      'regex',
      'rust',
      'svelte',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
      'zig',
    }

    local ts = require('nvim-treesitter')
    ts.install(filetypes)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter_folding', { clear = true }),
      desc = 'Enable Treesitter folding',
      callback = function(args)
        local bufnr = args.buf
        if vim.bo[bufnr].filetype ~= 'bigfile' and pcall(vim.treesitter.start, bufnr) then
          vim.api.nvim_buf_call(bufnr, function()
            vim.wo[0][0].foldmethod = 'expr'
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.cmd.normal('zx')
          end)
        end
      end,
    })
  end,
}
