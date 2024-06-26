-- Custom filetype detection logic with the new Lua filetype plugin
vim.filetype.add({
  extension = {
    cts = 'typescript',
    es6 = 'javascript',
    gif = 'image',
    jpeg = 'image',
    jpg = 'image',
    mts = 'typescript',
    png = 'image',
    postcss = 'css',
    rasi = 'rasi',
    sh = 'sh',
    zsh = 'sh',
  },
  filename = {
    ['.babelrc'] = 'json',
    ['.eslintrc'] = 'json',
    ['.prettierrc'] = 'json',
    ['.stylelintrc'] = 'json',
    ['sxhkdrc'] = 'sxhkdrc',
    ['.zshrc'] = 'sh',
    ['.zshenv'] = 'sh',
  },
  pattern = {
    ['.*config/git/config'] = 'gitconfig',
    ['.env.*'] = 'sh',
    ['.*/hypr/.*%.conf'] = 'hyprlang',
    ['todo%.txt'] = 'todotxt',
  },
})
