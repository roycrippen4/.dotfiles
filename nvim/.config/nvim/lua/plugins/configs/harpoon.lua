local harpoon = require('harpoon')

local files = {
  prepopulate = function()
    local Path = require('plenary.path')
    local cwd = vim.uv.cwd()
    local limit = 3
    return vim
      .iter(require('mini.visits').list_paths())
      :enumerate()
      :filter(function(i)
        return i <= limit
      end)
      :map(function(_, path)
        local p = Path:new(path):make_relative(cwd)
        local buf = vim.fn.bufnr(p, false)
        local row, col = 1, 1
        if buf and vim.api.nvim_buf_is_valid(buf) then
          if not vim.api.nvim_buf_is_loaded(buf) then
            vim.fn.bufload(buf)
          end
          row, col = unpack(vim.api.nvim_buf_get_mark(buf, '"'))
        end
        return {
          value = p,
          context = {
            row = row,
            col = col,
          },
        }
      end)
      :totable()
  end,
}

require('harpoon.config').DEFAULT_LIST = 'files'

harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
    key = function()
      return vim.uv.cwd() --[[@as string]]
    end,
  },
  files = files,
  default = {},
})

local Path = require('plenary.path')
local fidget = require('fidget')

local titles = {
  ADD = 'added',
  REMOVE = 'removed',
}

local function notify(event, cx)
  if not cx then
    return
  end

  if cx.list and cx.list.config.automated then
    return
  end
  local path = Path:new(cx.item.value) --[[@as Path]]

  local display = path:make_relative(vim.uv.cwd()) or path:make_relative(vim.env.HOME) or path:normalize()

  local handle = fidget.progress.handle.create({
    lsp_client = {
      name = 'harpoon',
    },
    title = titles[event],
    message = display,
    level = vim.log.levels.ERROR,
  })

  vim.defer_fn(function()
    handle:finish()
  end, 500)
end

local function handler(evt)
  return function(...)
    notify(evt, ...)
  end
end

---@param list HarpoonList
local function prepopulate(list)
  ---@diagnostic disable-next-line: undefined-field
  if list.config.prepopulate and list:length() == 0 then
    -- async via callback, or sync via return value
    local sync_items =
      ---@diagnostic disable-next-line: undefined-field
      list.config.prepopulate(function(items)
        if type(items) ~= 'table' then
          return
        end
        for _, item in ipairs(items) do
          list:append(item)
        end
        -- if ui is open, buffer needs to be updated
        -- so that items aren't removed immediately after being added
        vim.schedule(function()
          local ui_buf = harpoon.ui.bufnr
          if ui_buf and vim.api.nvim_buf_is_valid(ui_buf) then
            local lines = list:display()
            vim.api.nvim_buf_set_lines(ui_buf, 0, -1, false, lines)
          end
        end)
      end)
    if sync_items and type(sync_items) == 'table' then
      for _, item in ipairs(sync_items) do
        list:append(item)
      end
    end
  end
end

---@param win integer,
---@param fn fun(conf: vim.api.keyset.float_config): vim.api.keyset.float_config?
local function update_config(win, fn)
  local config = vim.api.nvim_win_get_config(win)
  local res = fn(config)
  if res ~= nil then
    config = res
  end
  vim.api.nvim_win_set_config(win, config)
end

harpoon:extend({
  ADD = handler('ADD'),
  REMOVE = handler('REMOVE'),
  UI_CREATE = function(cx)
    local win = cx.win_id
    vim.wo[win].cursorline = true
    vim.wo[win].signcolumn = 'no'

    update_config(win, function(config)
      config.footer = harpoon.ui.active_list.name
      config.footer_pos = 'center'
      return config
    end)

    vim.keymap.set('n', '<C-v>', function()
      harpoon.ui:select_menu_item({ vsplit = true })
    end, { buffer = cx.bufnr })
    vim.keymap.set('n', '<C-s>', function()
      harpoon.ui:select_menu_item({ split = true })
    end, { buffer = cx.bufnr })
  end,
  ---@param list HarpoonList
  LIST_READ = function(list)
    ---@diagnostic disable-next-line: undefined-field
    if list.config.automated then
      list:clear()
      prepopulate(list)
    end
  end,
  LIST_CREATED = prepopulate,
})
