---@type LazyPluginSpec
return {
  'saecki/crates.nvim', -- https://github.com/saecki/crates.nvim
  event = { 'BufRead Cargo.toml' },
  config = function()
    local crates = require('crates')
    crates.setup({
      lsp = { enabled = true, actions = true, completion = true },
      popup = { border = 'rounded' },
      completion = { crates = { enabled = true, min_chars = 3, max_results = 20 } },
    })

    local function version()
      crates.show_versions_popup()
      crates.focus_popup()
    end

    local function features()
      crates.show_features_popup()
      crates.focus_popup()
    end

    require('which-key').add({
      ---@type wk.Spec
      {
        mode = 'n',
        { '<leader>ct', crates.toggle, buffer = true, desc = '[C]rates toggle' },
        { '<leader>cr', crates.reload, buffer = true, desc = '[C]rates reload', icon = '󰑓' },
        { '<leader>cv', version, buffer = true, desc = '[C]rates versions', icon = '' },
        { '<leader>cf', features, buffer = true, desc = '[C]rates features', icon = '󰩉' },
        { '<leader>cd', crates.show_dependencies_popup, buffer = true, desc = '[C]rates dependencies', icon = '' },
        { '<leader>ca', crates.update_all_crates, buffer = true, desc = '[C]rates update all', icon = '󰚰' },
        { '<leader>cA', crates.upgrade_all_crates, buffer = true, desc = '[C]rates upgrade all', icon = '' },
        { '<leader>cH', crates.open_homepage, buffer = true, desc = '[C]rates open crate homepage', icon = '󰖟' },
        { '<leader>cR', crates.open_repository, buffer = true, desc = '[C]rates open crate repository', icon = '󰳏' },
        { '<leader>cD', crates.open_documentation, buffer = true, desc = '[C]rates open documentation', icon = '󰈙' },
        { '<leader>cC', crates.open_crates_io, buffer = true, desc = 'Open crates io', icon = '' },
        { '<leader>cu', crates.update_crate, buffer = true, desc = '[C]rates update crate', icon = '󰚰' },
        { '<leader>cU', crates.upgrade_crate, buffer = true, desc = '[C]rates upgrade crate', icon = '' },
      },
      {
        mode = 'v',
        { '<leader>cu', crates.update_crates, buffer = true, desc = '[C]rates update crates', icon = '󰚰' },
        { '<leader>cU', crates.upgrade_crates, buffer = true, desc = '[C]rates upgrade crates', icon = '' },
      },
    })
  end,
}
