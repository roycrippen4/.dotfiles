---Makes a given file executable
---@param file string Absolute path to the file
---@param current_perms string Current permissions of the file
---@return boolean
local function make_executable(file, current_perms)
  local perms = current_perms:gsub('-', 'x', 1)
  return vim.fn.setfperm(file, perms) and true or false
end

local function run_current_file()
  local path = vim.api.nvim_buf_get_name(0)
  local permissions = vim.fn.getfperm(path)
  local cmd = string.format('direction=horizontal size=16 cmd="%s"', path)

  if permissions:sub(3, 3) == 'x' then
    vim.cmd.TermExec(cmd)
    return
  end

  vim.ui.select(
    { 'yes', 'no' },
    { prompt = 'Make file executable?' },
    ---@param choice 'yes'|'no'
    function(choice)
      if choice == 'yes' then
        if make_executable(path, permissions) then
          vim.cmd.TermExec(cmd)
        else
          vim.notify('Failed to make file executable', vim.log.levels.ERROR)
        end
      end
    end
  )
end

vim.keymap.set('n', '<leader>lr', run_current_file, { desc = '[R]un current file', buffer = true })
