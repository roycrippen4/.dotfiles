local function run_file()
  vim.cmd.TermExec("direction=horizontal size=16 cmd='python3 " .. vim.fn.expand('%') .. "'")
end
vim.keymap.set('n', '<leader>lr', run_file, { desc = '[R]un current file', buffer = true })
