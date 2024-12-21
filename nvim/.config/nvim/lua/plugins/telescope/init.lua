---@type LazyPluginSpec
return {
  'nvim-telescope/telescope.nvim', -- https://github.com/nvim-telescope/telescope.nvim
  keys = require('plugins.telescope.keymaps'),
  dependencies = {
    -- stylua: ignore
    { 'cargo-bins/cargo-binstall', build = "curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash" },
    { 'sharkdp/fd', build = 'cargo binstall fd-find -y', dependencies = 'cargo-bins/cargo-binstall' },
    { 'BurntSushi/ripgrep', build = 'cargo binstall ripgrep', dependencies = 'cargo-bins/cargo-binstall' },
    { 'dandavison/delta', build = 'cargo binstall git-delta', dependencies = 'cargo-bins/cargo-binstall' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'debugloop/telescope-undo.nvim', keys = { { '<leader>u', '<cmd>Telescope undo<cr>' } } },
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'roycrippen4/telescope-treesitter-info.nvim',
  },
  config = function()
    local config = require('plugins.telescope.config')
    require('telescope').setup(config)
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('treesitter_info')
    require('telescope').load_extension('undo')
    require('plugins.telescope.keymaps').setup()
  end,
}
