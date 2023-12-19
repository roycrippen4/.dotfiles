-- Custom filetype detection logic with the new Lua filetype plugin
vim.filetype.add {
  extension = {
    cts = 'typescript',
    es6 = 'javascript',
    gif = 'image',
    jpeg = 'image',
    jpg = 'image',
    mdx = 'mdx',
    mts = 'typescript',
    png = 'image',
    sh = 'sh',
    zsh = 'sh',
  },
  filename = {
    ['.babelrc'] = 'json',
    ['.eslintrc'] = 'json',
    ['.prettierrc'] = 'json',
    ['.stylelintrc'] = 'json',
    ['.zshrc'] = 'sh',
    ['.zshenv'] = 'sh',
  },
  pattern = {
    ['.*config/git/config'] = 'gitconfig',
    ['.env.*'] = 'sh',
  },
}
