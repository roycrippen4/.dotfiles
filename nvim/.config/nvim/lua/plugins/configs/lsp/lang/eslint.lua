return {
  workingDirectory = {
    mode = 'auto',
  },
  rulesCustomizations = {
    {
      rule = 'no-unused-vars',
      severity = 'off',
    },
    {
      rule = '@typescript-eslint/no-unused-vars',
      severity = 'off',
    },
  },
}
