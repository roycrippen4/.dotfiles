return {
  'saecki/crates.nvim', --https://github.com/saecki/crates.nvim
  event = { 'BufRead Cargo.toml' },
  config = function()
    local map = vim.keymap.set
    local bufnr = vim.api.nvim_get_current_buf()

    map('n', '<leader>ct', require('crates').toggle, { buffer = bufnr, desc = 'Toggle' })
    map('n', '<leader>cr', require('crates').reload, { buffer = bufnr, desc = 'Reload' })
    map('n', '<leader>cv', require('crates').show_versions_popup, { buffer = bufnr, desc = 'Show versions_popup' })
    map('n', '<leader>cf', require('crates').show_features_popup, { buffer = bufnr, desc = 'Show features_popup' })
    map('n', '<leader>cd', require('crates').show_dependencies_popup, { buffer = bufnr, desc = 'Show dependencies popup' })
    map({ 'n', 'v' }, '<leader>cu', require('crates').update_crate, { buffer = bufnr, desc = 'Update crate(s)' })
    map({ 'n', 'v' }, '<leader>cU', require('crates').upgrade_crate, { buffer = bufnr, desc = 'Upgrade crate(s)' })
    map('n', '<leader>ca', require('crates').update_all_crates, { buffer = bufnr, desc = 'Update all crates' })
    map('n', '<leader>cA', require('crates').upgrade_all_crates, { buffer = bufnr, desc = 'Upgrade all crates' })
    map('n', '<leader>ce', require('crates').expand_plain_crate_to_inline_table, { buffer = bufnr, desc = 'Crate to inline' })
    map('n', '<leader>cE', require('crates').extract_crate_into_table, { buffer = bufnr, desc = 'Extract crate into table' })
    map('n', '<leader>cH', require('crates').open_homepage, { buffer = bufnr, desc = 'Open homepage' })
    map('n', '<leader>cR', require('crates').open_repository, { buffer = bufnr, desc = 'Open repository' })
    map('n', '<leader>cD', require('crates').open_documentation, { buffer = bufnr, desc = 'Open documentation' })
    map('n', '<leader>cC', require('crates').open_crates_io, { buffer = bufnr, desc = 'Open crates io' })
    require('crates').setup({})
  end,
}
