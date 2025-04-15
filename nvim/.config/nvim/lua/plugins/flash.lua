---@module "flash"
---@type LazyPluginSpec
return {
  'folke/flash.nvim', -- https//github.com/folke/flash.nvim
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    prompt = {
      win_config = { border = 'none' },
    },
  },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", false, mode = { 'v' } },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
