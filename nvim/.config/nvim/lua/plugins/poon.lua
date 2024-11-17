---@module "poon"
---@type LazyPluginSpec
return {
  'roycrippen4/poon.nvim',
  dev = false,
  lazy = false,
  keys = {
    -- stylua: ignore start
    { '<C-S-D>', function() require('poon').mark.remove()    end },
    { '<c-f>',   function() require('poon').mark.set()       end },
    { 'B',       function() require('poon').mark.set_first() end },
    { '<c-e>',   function() require('poon').menu.toggle()    end },
    { '<c-1>',   function() require('poon').mark.jump(1)     end },
    { '<c-2>',   function() require('poon').mark.jump(2)     end },
    { '<c-3>',   function() require('poon').mark.jump(3)     end },
    { '<c-4>',   function() require('poon').mark.jump(4)     end },
    { '<c-5>',   function() require('poon').mark.jump(5)     end },
    { '<c-6>',   function() require('poon').mark.jump(6)     end },
    { '<c-7>',   function() require('poon').mark.jump(7)     end },
    { '<c-8>',   function() require('poon').mark.jump(8)     end },
    { '<c-9>',   function() require('poon').mark.jump(9)     end },
    -- stylua: ignore end
  },
  ---@type poon.Config
  opts = { restore_on_startup = true },
}
