-- local fn = vim.fn
-- local map = vim.keymap.set
-- local ms = vim.lsp.protocol.Methods

-- --- Returns the height of the buffer in the window
-- ---@param winnr integer
-- ---@return integer
-- local function win_buf_height(winnr)
--   local buf = api.nvim_win_get_buf(winnr)

--   if not vim.wo[winnr].wrap then
--     return api.nvim_buf_line_count(buf)
--   end

--   local width = api.nvim_win_get_width(winnr)
--   local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
--   local height = 0
--   vim.iter(lines):each(function(l)
--     height = height + math.max(1, (math.ceil(fn.strwidth(l) / width)))
--   end)
--   return height
-- end

-- --- Scrolls the window by delta lines
-- ---@param winnr integer
-- ---@param delta integer
-- local function scroll(winnr, delta)
--   local info = fn.getwininfo(winnr)[1] or {}
--   local top = info.topline or 1

--   if not vim.api.nvim_win_is_valid(winnr) then
--     return
--   end

--   local buf = api.nvim_win_get_buf(winnr)
--   top = top + delta
--   top = math.max(top, 1)
--   top = math.min(top, win_buf_height(winnr) - info.height + 1)

--   vim.defer_fn(function()
--     api.nvim_buf_call(buf, function()
--       api.nvim_command('noautocmd silent! normal! ' .. top .. 'zt')
--       api.nvim_exec_autocmds('WinScrolled', { modeline = false })
--     end)
--   end, 0)
-- end

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
  show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(diag1, diag2)
      return diag1.severity > diag2.severity
    end)
    return show_handler(ns, bufnr, diagnostics, opts)
  end,
  hide = hide_handler,
}

local md_namespace = vim.api.nvim_create_namespace('lsp_float')

--- Adds extra inline highlights to the given buffer.
---@param buf integer
local function add_inline_highlights(buf)
  for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    for pattern, hl_group in pairs({
      ['@%S+'] = '@parameter',
      ['^%s*(Parameters:)'] = '@text.title',
      ['^%s*(Return:)'] = '@text.title',
      ['^%s*(See also:)'] = '@text.title',
      ['{%S-}'] = '@parameter',
      ['|%S-|'] = '@text.reference',
    }) do
      local from = 1 ---@type integer?
      while from do
        local to
        from, to = line:find(pattern, from)
        if from then
          vim.api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
            end_col = to,
            hl_group = hl_group,
          })
        end
        from = to and to + 1 or nil
      end
    end
  end
end

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover({
    border = 'rounded',
    max_height = math.floor(vim.o.lines * 0.3),
    max_width = math.floor(vim.o.columns * 0.4),
  })
end

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
  return signature_help({
    border = 'rounded',
    max_height = math.floor(vim.o.lines * 0.3),
    max_width = math.floor(vim.o.columns * 0.4),
  })
end

-- --- LSP handler that adds extra inline highlights, keymaps, and window options.
-- --- Code inspired from `noice`.
-- ---@param handler fun(err: any, result: any, ctx: any, config: any): integer?, integer?
-- ---@param focusable boolean
-- ---@return fun(err: any, result: any, ctx: any, config: any)
-- local function enhanced_float_handler(handler, focusable)
--   local limit = vim.o.lines * 0.3
--   return function(err, result, ctx, config)
--     config = config or { silent = true }
--     local bufnr, winnr = handler(
--       err,
--       result,
--       ctx,
--       vim.tbl_deep_extend('force', config or {}, {
--         border = 'rounded',
--         focusable = focusable,
--         max_height = math.floor(limit),
--         max_width = math.floor(vim.o.columns * 0.4),
--       })
--     )

--     if not bufnr or not winnr then
--       return
--     end

--     add_inline_highlights(bufnr)
--     vim.wo[winnr].concealcursor = 'n'
--     vim.wo[winnr].scrolloff = 0

--     -- stylua: ignore start
--     map({ 'n', 'i' }, '<C-S-N>', function() scroll(winnr, 4) end, { buffer = true })
--     map({ 'n', 'i' }, '<C-S-P>', function() scroll(winnr, -4) end, { buffer = true })
--     -- stylua: ignore end

--     if focusable and not vim.b[bufnr].markdown_keys then
--       map('n', 'K', function()
--         local url = (fn.expand('<cWORD>') --[[@as string]]):match('|(%S-)|')
--         if url then
--           return vim.cmd.help(url)
--         end

--         local col = api.nvim_win_get_cursor(0)[2] + 1
--         local from, to
--         from, to, url = api.nvim_get_current_line():find('%[.-%]%((%S-)%)')
--         if from and col >= from and col <= to then
--           vim.system({ 'xdg-open', url }, nil, function(res)
--             if res.code ~= 0 then
--               vim.notify('Failed to open URL' .. url, vim.log.levels.ERROR)
--             end
--           end)
--         end
--       end, { buffer = bufnr, silent = true })
--       vim.b[bufnr].markdown_keys = true
--     end
--   end
-- end

-- lsp.handlers[ms.textDocument_hover] = enhanced_float_handler(lsp.handlers.hover, true)
-- lsp.handlers[ms.textDocument_signatureHelp] = enhanced_float_handler(lsp.handlers.signature_help, false)

---@param bufnr integer
---@param contents string[]
---@param opts table
---@return string[]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
  contents = vim.lsp.util._normalize_markdown(contents, {
    width = vim.lsp.util._make_floating_popup_size(contents, opts),
  })
  vim.bo[bufnr].filetype = 'markdown'
  vim.treesitter.start(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

  add_inline_highlights(bufnr)

  return contents
end

---@type LazyPluginSpec
return {
  'neovim/nvim-lspconfig', -- https://github.com/neovim/nvim-lspconfig
  event = 'BufReadPre',
  dependencies = {
    'williamboman/mason.nvim', -- https://github.com/williamboman/mason.nvim
    'b0o/schemastore.nvim', -- https://github.com/b0o/schemastore.nvim
    { 'j-hui/fidget.nvim', opts = {} }, -- https://github.com/j-hui/fidget.nvim
    { 'p00f/clangd_extensions.nvim', opts = {}, ft = { 'c', 'cpp' } },
    { 'Civitasv/cmake-tools.nvim', opts = {}, ft = { 'c', 'cpp' } },
  },
  config = function()
    local lspconfig = require('lspconfig')

    lspconfig['clangd'].setup({
      root_dir = function(fname)
        return require('lspconfig.util').root_pattern(
          'Makefile',
          'configure.ac',
          'configure.in',
          'config.h.in',
          'meson.build',
          'meson_options.txt',
          'build.ninja'
        )(fname) or require('lspconfig.util').root_pattern('compile_commands.json', 'compile_flags.txt')(fname) or require(
          'lspconfig.util'
        ).find_git_ancestor(fname)
      end,
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=iwyu',
        '--completion-style=detailed',
        '--function-arg-placeholders',
        '--fallback-style=llvm',
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
      filetypes = { 'c', 'cpp' },
      capabilities = vim.tbl_deep_extend('force', U.capabilities, { offsetEncoding = { 'utf-16' } }),
      on_attach = U.on_attach,
    })

    lspconfig['cssls'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
      settings = {
        css = {
          validate = true,
          lint = { unknownAtRules = 'ignore' },
        },
      },
    })

    lspconfig['vtsls'].setup({
      on_attach = U.on_attach,
      capabilities = U.capabilities,
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
      settings = {
        complete_function_calls = true,
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = {
              enableServerSideFuzzyMatch = true,
            },
          },
        },
        typescript = {
          updateImportsOnFileMove = { enabled = 'always' },
          suggest = {
            completeFunctionCalls = true,
          },
          inlayHints = {
            enumMemberValues = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
            parameterNames = { enabled = 'literals' },
            parameterTypes = { enabled = true },
            propertyDeclarationTypes = { enabled = true },
            variableTypes = { enabled = false },
          },
        },
      },
    })

    lspconfig['docker_compose_language_service'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
    })

    lspconfig['dockerls'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
    })

    lspconfig['eslint'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
    })

    lspconfig['gopls'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
    })

    lspconfig['hls'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
    })

    lspconfig['html'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
    })

    lspconfig['hyprls'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
    })

    lspconfig['jsonls'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    lspconfig['lua_ls'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
      settings = {
        Lua = {
          format = { enable = false },
          diagnostics = { globals = { 'vim' } },
          telemetry = { enable = false },
          hint = { enable = true, arrayIndex = 'Disable' },
        },
      },
    })

    lspconfig['marksman'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
    })

    lspconfig['ocamllsp'].setup({
      root_dir = lspconfig.util.root_pattern('*.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace', '*.ml'),
      capabilities = U.capabilities,
      on_attach = U.on_attach,
    })

    lspconfig['pyright'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
    })

    lspconfig['svelte'].setup({
      capabilities = vim.tbl_deep_extend(
        'force',
        U.capabilities,
        { workspace = { didChangeOnWatchedFiles = { dynamicRegistration = true } } }
      ),
      on_attach = U.on_attach,
    })

    lspconfig['taplo'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
      settings = {
        taplo = {
          configFile = { enabled = true },
          catalogs = { 'https://www.schemastore.org/api/json/catalog.json' },
          cache = { memoryExpiration = 60, diskExpiration = 600 },
        },
      },
    })

    if U.has_file('biome.json') then
      lspconfig['biome'].setup({
        capabilities = U.capabilities,
        on_attach = U.on_attach,
      })
    end

    lspconfig['yamlls'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
      settings = {
        yaml = {
          schemaStore = { enable = false, url = '' },
          scehmas = require('schemastore').yaml.schemas(),
        },
      },
    })

    vim.g.zig_fmt_parse_errors = 0
    lspconfig['zls'].setup({
      capabilities = U.capabilities,
      on_attach = U.on_attach,
      root_dir = lspconfig.util.root_pattern('.git', 'build.zig', 'zls.json'),
      settings = {
        zls = {
          enable_inlay_hints = true,
          enable_snippets = true,
          warn_style = true,
        },
      },
    })

    lspconfig['protols'].setup({})
  end,
}
