require('nvim-surround').buffer_setup({
  surrounds = {
    F = {
      add = function()
        return {
          { ('function %s() '):format(require('nvim-surround.config').get_input('Enter the function name: ')) },
          { ' end' },
        }
      end,
    },
  },
})
