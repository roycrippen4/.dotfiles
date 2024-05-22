return {
  'roycrippen4/buffer-logger.nvim',
  config = function()
    local logger = require('logger')
    logger:setup({ show_on_start = false })

    vim.keymap.set('n', '<leader>ls', function()
      require('logger'):toggle()
    end)

    function _G.log(...)
      logger:log(...)
    end
  end,
}
