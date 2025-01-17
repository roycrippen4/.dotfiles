---@diagnostic disable: undefined-global
return {
  postfix('.promise', {
    f(function(_, parent)
      return 'Promise<' .. parent.snippet.env.POSTFIX_MATCH .. '>'
    end, {}),
  }),
}
