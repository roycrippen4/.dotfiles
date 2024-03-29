local map = vim.keymap.set

require('which-key').register({
  ['<leader>c'] = { 'Crates  ' },
})

local bufnr = vim.api.nvim_get_current_buf()

map('n', '<leader>ct', require('crates').toggle, { silent = true, buffer = bufnr, desc = 'Toggle' })
map('n', '<leader>cr', require('crates').reload, { silent = true, buffer = bufnr, desc = 'Reload' })
map('n', '<leader>cv', require('crates').show_versions_popup, { silent = true, buffer = bufnr, desc = 'Show versions_popup' })
map('n', '<leader>cf', require('crates').show_features_popup, { silent = true, buffer = bufnr, desc = 'Show features_popup' })
map('n', '<leader>cd', require('crates').show_dependencies_popup, { silent = true, buffer = bufnr, desc = 'Show dependencies popup' })
map({ 'n', 'v' }, '<leader>cu', require('crates').update_crate, { silent = true, buffer = bufnr, desc = 'Update crate(s)' })
map({ 'n', 'v' }, '<leader>cU', require('crates').upgrade_crate, { silent = true, buffer = bufnr, desc = 'Upgrade crate(s)' })
map('n', '<leader>ca', require('crates').update_all_crates, { silent = true, buffer = bufnr, desc = 'Update all crates' })
map('n', '<leader>cA', require('crates').upgrade_all_crates, { silent = true, buffer = bufnr, desc = 'Upgrade all crates' })
map('n', '<leader>ce', require('crates').expand_plain_crate_to_inline_table, { silent = true, buffer = bufnr, desc = 'Crate to inline' })
map('n', '<leader>cE', require('crates').extract_crate_into_table, { silent = true, buffer = bufnr, desc = 'Extract crate into table' })
map('n', '<leader>cH', require('crates').open_homepage, { silent = true, buffer = bufnr, desc = 'Open homepage' })
map('n', '<leader>cR', require('crates').open_repository, { silent = true, buffer = bufnr, desc = 'Open repository' })
map('n', '<leader>cD', require('crates').open_documentation, { silent = true, buffer = bufnr, desc = 'Open documentation' })
map('n', '<leader>cC', require('crates').open_crates_io, { silent = true, buffer = bufnr, desc = 'Open crates io' })
