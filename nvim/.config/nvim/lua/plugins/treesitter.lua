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
      group = vim.api.nvim_create_augroup('treesitter.setup', {}),
      pattern = filetypes,
      callback = function(args)
        local buf = args.buf
        local ft = args.match

        local lang = vim.treesitter.language.get_lang(ft) or ft
        if not vim.treesitter.language.add(lang) then
          return
        end

        if vim.api.nvim_buf_line_count(buf) < 50000 then
          vim.treesitter.start()
        else
          vim.notify('Big file detected. Disabling treesitter highlighting')
          vim.treesitter.stop(buf)
        end
      end,
    })
  end,
}
