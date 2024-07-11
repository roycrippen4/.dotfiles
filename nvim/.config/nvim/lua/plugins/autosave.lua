return {
  'okuuva/auto-save.nvim',
  cmd = 'ASToggle',
  event = { 'InsertLeave', 'TextChanged' },
  opts = {
    execution_message = {
      enabled = true,
      message = '',
    },
  },
}
