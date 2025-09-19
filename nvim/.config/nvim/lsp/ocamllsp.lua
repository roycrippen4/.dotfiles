local function strip_archive_subpath(path)
  path = vim.fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
  path = vim.fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
  return path
end

local function search_ancestors(startpath, func)
  if func(startpath) then
    return startpath
  end

  local guard = 100
  for path in vim.fs.parents(startpath) do
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

local function escape_wildcards(path)
  return path:gsub('([%[%]%?%*])', '\\%1')
end

local function root_pattern(...)
  local patterns = vim.iter({ ... }):flatten(math.huge):totable()

  return function(startpath)
    startpath = strip_archive_subpath(startpath)
    for _, pattern in ipairs(patterns) do
      local match = search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, '/'), true, true)) do
          if vim.uv.fs_stat(p) then
            return path
          end
        end
      end)

      if match ~= nil then
        return match
      end
    end
  end
end

local language_id_of = {
  menhir = 'ocaml.menhir',
  ocaml = 'ocaml',
  ocamlinterface = 'ocaml.interface',
  ocamllex = 'ocaml.ocamllex',
  reason = 'reason',
  dune = 'dune',
}

local function get_language_id(_, ftype)
  return language_id_of[ftype]
end

---@type vim.lsp.Config
return {
  cmd = { 'ocamllsp' },
  cmd_env = { DUNE_BUILD_DIR = '_build_lsp' },
  settings = {
    codelens = { enable = true },
    inlayHints = {
      hintPatternVariables = true,
      hintLetBindings = true,
      hintFunctionParams = true,
    },
    extendedHover = { enable = true },
    syntaxDocumentation = { enable = true },
    merlinJumpCodeActions = { enable = true },
  },
  filetypes = { 'ocaml', 'menhir', 'ocamlinterface', 'ocamllex', 'reason', 'dune' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(root_pattern('*.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace')(fname))
  end,
  get_language_id = get_language_id,
}
