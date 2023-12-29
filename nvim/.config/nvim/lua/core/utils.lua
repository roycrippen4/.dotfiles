local M = {}
local merge_tb = vim.tbl_deep_extend

function M.debounce(ms, fn)
  local timer = vim.loop.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

--- test description
function M.simple_write()
  vim.cmd([[
    silent w
    echo 'File Saved'
  ]])
end

_G.log = function(msg)
  if type(msg) ~= 'string' then
    msg = vim.inspect(msg)
  end
  require('core.proto_plugs.logger'):log(msg)
end

---@param param any item to look for in case_table
---@param case_table table the cases
---@return any result the definition for the match in the case_table
---or the default function/nil if no match
--[[
```lua
switch(a, { 
  [1] = function()	-- for case 1
		print "Case 1."
	end,
	[2] = function()	-- for case 2
		print "Case 2."
	end,
	[3] = function()	-- for case 3
		print "Case 3."
	end
  ['default'] = function()
    -- handle default case here
  end
})

```
]]
_G.switch = function(param, case_table)
  local case = case_table[param]
  if case then
    return case()
  end
  local def = case_table['default']
  return def and def() or nil
end

M.load_config = function()
  local config = require('core.default_config')
  local chadrc_path = vim.api.nvim_get_runtime_file('lua/custom/chadrc.lua', false)[1]

  if chadrc_path then
    local chadrc = dofile(chadrc_path)

    config.mappings = M.remove_disabled_keys(chadrc.mappings, config.mappings)
    config = merge_tb('force', config, chadrc)
    config.mappings.disabled = nil
  end

  return config
end

M.remove_disabled_keys = function(chadrc_mappings, default_mappings)
  if not chadrc_mappings then
    return default_mappings
  end

  -- store keys in a array with true value to compare
  local keys_to_disable = {}
  for _, mappings in pairs(chadrc_mappings) do
    for mode, section_keys in pairs(mappings) do
      if not keys_to_disable[mode] then
        keys_to_disable[mode] = {}
      end
      section_keys = (type(section_keys) == 'table' and section_keys) or {}
      for k, _ in pairs(section_keys) do
        keys_to_disable[mode][k] = true
      end
    end
  end

  -- make a copy as we need to modify default_mappings
  for section_name, section_mappings in pairs(default_mappings) do
    for mode, mode_mappings in pairs(section_mappings) do
      mode_mappings = (type(mode_mappings) == 'table' and mode_mappings) or {}
      for k, _ in pairs(mode_mappings) do
        -- if key if found then remove from default_mappings
        if keys_to_disable[mode] and keys_to_disable[mode][k] then
          default_mappings[section_name][mode][k] = nil
        end
      end
    end
  end

  return default_mappings
end

M.load_mappings = function(section, mapping_opt)
  vim.schedule(function()
    local function set_section_map(section_values)
      if section_values.plugin then
        return
      end

      section_values.plugin = nil

      for mode, mode_values in pairs(section_values) do
        local default_opts = merge_tb('force', { mode = mode }, mapping_opt or {})
        for keybind, mapping_info in pairs(mode_values) do
          -- merge default + user opts
          local opts = merge_tb('force', default_opts, mapping_info.opts or {})

          mapping_info.opts, opts.mode = nil, nil
          opts.desc = mapping_info[2]

          vim.keymap.set(mode, keybind, mapping_info[1], opts)
        end
      end
    end

    local mappings = require('nvconfig').mappings

    if type(section) == 'string' then
      mappings[section]['plugin'] = nil
      mappings = { mappings[section] }
    end

    for _, sect in pairs(mappings) do
      set_section_map(sect)
    end
  end)
end

M.lazy_load = function(plugin)
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufWinEnter', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('BeLazyOnFileOpen' .. plugin, {}),
    callback = function()
      local file = vim.fn.expand('%')
      local condition = file ~= '[lazy]' and file ~= ''

      if condition then
        vim.api.nvim_del_augroup_by_name('BeLazyOnFileOpen' .. plugin)

        -- dont defer for treesitter as it will show slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        if plugin ~= 'nvim-treesitter' then
          vim.schedule(function()
            require('lazy').load({ plugins = plugin })

            if plugin == 'nvim-lspconfig' then
              vim.cmd('silent! do FileType')
            end
            ---@diagnostic disable-next-line
          end, 0)
        else
          require('lazy').load({ plugins = plugin })
        end
      end
    end,
  })
end

function M.map(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap
  if type(modes) == 'string' then
    modes = { modes }
  end
  for _, mode in ipairs(modes) do
    if type(rhs) == 'string' then
      vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    else
      opts.callback = rhs
      vim.api.nvim_set_keymap(mode, lhs, '', opts)
    end
  end
end

function M.termcode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Bust the cache of all required Lua files.
-- After running this, each require() would re-run the file.
local function unload_all_modules()
  -- Lua patterns for the modules to unload
  local unload_modules = {
    '^j.',
  }

  for k, _ in pairs(package.loaded) do
    for _, v in ipairs(unload_modules) do
      if k:match(v) then
        package.loaded[k] = nil
        break
      end
    end
  end
end

function M.reload()
  -- Stop LSP
  vim.cmd.LspStop()

  -- Stop eslint_d
  vim.fn.execute('silent !pkill -9 eslint_d')

  -- Unload all already loaded modules
  unload_all_modules()

  -- Source init.lua
  vim.cmd.luafile('$MYVIMRC')
end

-- Restart Vim without having to close and run again
function M.restart()
  -- Reload config
  M.reload()

  -- Manually run VimEnter autocmd to emulate a new run of Vim
  vim.cmd.doautocmd('VimEnter')
end

---@return integer width returns the width of the nvimtree buffer
function M.get_nvim_tree_width()
  for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].ft == 'NvimTree' then
      return vim.api.nvim_win_get_width(win) + 1
    end
  end
  return 0
end

--- Sets the title in the overlay section above nvimtree
function M.set_nvim_tree_overlay_title()
  local title = 'File Tree'
  local tree_width = M.get_nvim_tree_width()

  -- early return if tree is not shown
  if tree_width == 0 then
    vim.g.NvimTreeOverlayTitle = ''
    return
  end

  -- Set the title if the tree is shown, but no buffers are open
  if #vim.t.bufs == 0 then
    local start_title = vim.loop.cwd()
    vim.g.NvimTreeOverlayTitle = '%#NvimTreeTitle#' .. start_title
    return
  end

  -- Set the title if the tree is shown and buffers are open
  local width = tree_width - #title
  local padding = string.rep(' ', math.floor(width / 2))
  local title_with_pad = padding .. title .. padding
  if tree_width % 2 == 0 then
    vim.g.NvimTreeOverlayTitle = '%#NvimTreeTitle#' .. title_with_pad
  else
    vim.g.NvimTreeOverlayTitle = '%#NvimTreeTitle#' .. string.sub(title_with_pad, 0, -2)
  end
end

--- Function to easily determine if a string contains another string.
---@param sub string sub-string to search
---@param container string the string that may contain the sub
---@return boolean result true if container contains sub. false if it does not.
function M.contains(container, sub)
  return string.find(container, sub) ~= nil
end

--- Is the buffer named NvimTree_[0-9]+ a tree? filetype is "NvimTree" or not readable file.
--- This is cheap, as the readable test should only ever be needed when resuming a vim session.
---@param bufnr number|nil may be 0 or nil for current
---@return boolean
function M.is_nvim_tree_buf(bufnr)
  if bufnr == nil then
    bufnr = 0
  end

  if vim.api.nvim_buf_is_valid(bufnr) then
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if vim.fn.filereadable(bufname) == 0 then
      return true
    end
  end
  return false
end

M.set_titlestring = function(cwd)
  local env = os.getenv('HOME')

  if cwd == env then
    vim.o.titlestring = '~/' .. '  '
    return
  end

  if cwd and type(env) == 'string' then
    local match = string.match(cwd, env)
    if match then
      vim.o.titlestring = cwd:gsub(match, '~') .. '  '
      return
    end
    vim.o.titlestring = cwd
  end
end

M.on_stdout = function(_, _, data, _)
  print(data)
end

M.set_node_version = function(cwd)
  local nvmrc_filepath = cwd .. '/.nvmrc'
  local nvmrc_exists = vim.fn.filereadable(nvmrc_filepath) == 1
  if cwd and vim.fn.isdirectory(vim.fn.expand(cwd)) == 0 then
    cwd = nil
  end

  if nvmrc_exists then
    local term = require('toggleterm.terminal').get_or_create_term(1001, cwd, 'horizontal')
    term:spawn()
    term:send('nvm use')
    vim.notify('Detected .nvmrc file. Switching node version...')
  end
end

---@return Array returns the names of currently open buffers that are marked
function M.get_marked_bufs()
  local paths = {}
  local buffers = vim.api.nvim_list_bufs()

  for _, bufnr in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local name = vim.api.nvim_buf_get_name(bufnr)
      local path = require('plenary.path'):new(name):make_relative()
      if path ~= '.' then
        table.insert(paths, path)
      end
    end
  end

  local marked_bufs = {}
  local items = require('harpoon'):list('default').items

  for _, item in ipairs(items) do
    if vim.tbl_contains(paths, item.value) then
      table.insert(marked_bufs, item.value)
    end
  end
  return marked_bufs
end

M.toggle = 0

local function toggle_recording_hl()
  if M.toggle == 0 then
    vim.api.nvim_set_hl(0, 'ST_Macro', { link = 'ST_MacroA' })
    vim.api.nvim_set_hl(0, 'ST_MacroSep', { link = 'ST_MacroSepA' })
    M.toggle = 1
  else
    vim.api.nvim_set_hl(0, 'ST_Macro', { link = 'ST_MacroB' })
    vim.api.nvim_set_hl(0, 'ST_MacroSep', { link = 'ST_MacroSepB' })
    M.toggle = 0
  end
end

M.hl_timer = vim.loop.new_timer()

function M.start_record_highlight()
  M.hl_timer:start(
    0,
    500,
    vim.schedule_wrap(function()
      toggle_recording_hl()
    end)
  )
end

function M.stop_timer()
  M.hl_timer:stop()
end

return M
