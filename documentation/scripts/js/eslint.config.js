import { ESLint } from 'eslint';

export default new ESLint({
  overrideConfig: {
    env: {
      browser: true,
      es2021: true,
      node: true,
    },
    extends: ['eslint:recommended', 'plugin:prettier/recommended'],
    plugins: ['prettier'],
    languageOptions: {
      parser: '@babel/eslint-parser',
      parserOptions: {
        requireConfigFile: false,
        ecmaVersion: 12,
        sourceType: 'module',
      },
    },
    rules: {
      'prettier/prettier': 'error',
    },
  },
});
