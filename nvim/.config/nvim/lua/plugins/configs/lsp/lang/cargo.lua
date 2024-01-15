local wk = require('which-key')

wk.register({
  --[===========================================================================]
  --[------------------------------- CRATES ------------------------------------]
  --[===========================================================================]
  ['<leader>c'] = { 'Crates  ' },
  ['<leader>ct'] = { name = 'Toggle', _ = 'which_key_ignore' },
  ['<leader>cr'] = { name = 'Reload', _ = 'which_key_ignore' },
  ['<leader>cv'] = { name = 'Show versions_popup', _ = 'which_key_ignore' },
  ['<leader>cf'] = { name = 'Show features_popup', _ = 'which_key_ignore' },
  ['<leader>cd'] = { name = 'Show dependencies popup', _ = 'which_key_ignore' },
  ['<leader>cu'] = { name = 'Update crate(s)', mode = { 'n', 'v' }, _ = 'which_key_ignore' },
  ['<leader>ca'] = { name = 'Update all crates', _ = 'which_key_ignore' },
  ['<leader>cU'] = { name = 'Upgrade crate(s)', mode = { 'n', 'v' }, _ = 'which_key_ignore' },
  ['<leader>cA'] = { name = 'Upgrade all crates', _ = 'which_key_ignore' },
  ['<leader>ce'] = { name = 'Expand plain crate to inline table', _ = 'which_key_ignore' },
  ['<leader>cE'] = { name = 'Extract crate into table', _ = 'which_key_ignore' },
  ['<leader>cH'] = { name = 'Open homepage', _ = 'which_key_ignore' },
  ['<leader>cR'] = { name = 'Open repository', _ = 'which_key_ignore' },
  ['<leader>cD'] = { name = 'Open documentation', _ = 'which_key_ignore' },
  ['<leader>cC'] = { name = 'Open crates io', _ = 'which_key_ignore' },
})

local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set('n', '<leader>ct', function()
  require('crates').toggle()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cr', function()
  require('crates').reload()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cv', function()
  require('crates').show_versions_popup()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cf', function()
  require('crates').show_features_popup()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cd', function()
  require('crates').show_dependencies_popup()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cu', function()
  require('crates').update_crate()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>ca', function()
  require('crates').update_all_crates()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cU', function()
  require('crates').upgrade_crate()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cA', function()
  require('crates').upgrade_all_crates()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>ce', function()
  require('crates').expand_plain_crate_to_inline_table()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cE', function()
  require('crates').extract_crate_into_table()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cH', function()
  require('crates').open_homepage()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cR', function()
  require('crates').open_repository()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cD', function()
  require('crates').open_documentation()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cC', function()
  require('crates').open_crates_io()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cu', function()
  require('crates').update_crates()
end, { silent = true, buffer = bufnr })

vim.keymap.set('n', '<leader>cU', function()
  require('crates').upgrade_crates()
end, { silent = true, buffer = bufnr })
