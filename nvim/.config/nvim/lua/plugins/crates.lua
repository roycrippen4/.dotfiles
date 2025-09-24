---@type LazyPluginSpec
---@module "crates"
return {
  'saecki/crates.nvim', -- https://github.com/saecki/crates.nvim
  event = { 'BufRead Cargo.toml' },
  ---@type crates.UserConfig
  opts = {
    lsp = { enabled = true, actions = true, completion = true },
    popup = { border = 'rounded' },
    completion = { crates = { enabled = true, min_chars = 3, max_results = 20 } },
  },
}
