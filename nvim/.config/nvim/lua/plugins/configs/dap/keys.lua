return {
  {
    '<Leader>dc',
    function()
      require('dap').continue()
    end,
    desc = ' Continue',
  },
  {
    '<Leader>do',
    function()
      require('dap').step_over()
    end,
    desc = ' Step Over',
  },
  {
    '<Leader>dO',
    function()
      require('dap').step_out()
    end,
    desc = ' Step out',
  },
  {
    '<Leader>di',
    function()
      require('dap').step_into()
    end,
    desc = ' Step into',
  },
  {
    '<Leader>db',
    function()
      require('dap').toggle_breakpoint()
    end,
    desc = ' Toggle breakpoint',
  },
}
