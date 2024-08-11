---@type LazyPluginSpec
return {
  'roycrippen4/buffer-logger.nvim',
  config = function()
    local logger = require('logger')
    logger:setup({ show_on_start = false })

    require('which-key').add({
      {
        mode = 'n',
        {
          '<leader>L',
          function()
            logger:toggle()
          end,
          desc = '[L]ogger',
          icon = '󰗽',
        },
      },
    })

    function _G.log(...)
      logger:log(...)
    end
  end,
}
