local M = {}
local merge_tb = vim.tbl_deep_extend

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
        if plugin ~= 'nvim-treesitter' then
          vim.defer_fn(function()
            require('lazy').load({ plugins = plugin })
            if plugin == 'nvim-lspconfig' then
              vim.cmd('silent! do FileType')
            end
          end, 0)
        else
          require('lazy').load({ plugins = plugin })
        end
      end
    end,
  })
end

-- function M.map(modes, lhs, rhs, opts)
--   opts = opts or {}
--   opts.noremap = opts.noremap == nil and true or opts.noremap
--   if type(modes) == 'string' then
--     modes = { modes }
--   end
--   for _, mode in ipairs(modes) do
--     if type(rhs) == 'string' then
--       vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
--     else
--       opts.callback = rhs
--       vim.api.nvim_set_keymap(mode, lhs, '', opts)
--     end
--   end
-- end

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

--- Is the buffer named NvimTree_[0-9]+ a tree? filetype is "NvimTree" or not readable file.
--- This is cheap, as the readable test should only ever be needed when resuming a vim session.
-- function M.is_nvim_tree_buf(bufnr)
--   if bufnr == nil then
--     bufnr = 0
--   end

--   if vim.api.nvim_buf_is_valid(bufnr) then
--     local bufname = vim.api.nvim_buf_get_name(bufnr)
--     if vim.fn.filereadable(bufname) == 0 then
--       return true
--     end
--   end
--   return false
-- end

return M
