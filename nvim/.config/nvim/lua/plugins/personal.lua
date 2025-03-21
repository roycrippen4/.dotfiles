---@type LazyPluginSpec[]
return {
  {
    --- Harpoon clone
    'roycrippen4/poon.nvim', -- https://github.com/roycrippen4/poon.nvim
    lazy = true,
    keys = {
      -- stylua: ignore start
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
    opts = {},
  },
  {
    --- Sroll eof implementation
    'roycrippen4/scrool.nvim', -- https://github.com/roycrippen4/scrool.nvim
    opts = {},
  },
  {
    --- Statusline and bufferline
    'roycrippen4/beeline.nvim', -- https://github.com/roycrippen4/beeline.nvim
    lazy = false,
    keys = {
      { '<leader>x', '<cmd>BeelineBufClose<cr>', { desc = 'Close buffer' } },
      { 'H', '<cmd>BeelineBufPrev<cr>', { desc = 'Go to previous beeline buffer' } },
      { 'L', '<cmd>BeelineBufNext<cr>', { desc = 'Go to next beeline buffer' } },
    },
    opts = {},
  },
  {
    --- Highlight group inspection tools
    'roycrippen4/inspector.nvim', -- https://github.com/roycrippen4/inspector.nvim
    -- stylua: ignore
    keys = {
      { '<leader>if', function() require('inspector').inspect_in_float() end, desc = "[I]nspect in float" },
      { '<leader>iw', function() require('inspector').inspect_in_split() end, desc = "[I]nspect in split" },
    },
    opts = {},
  },
}
