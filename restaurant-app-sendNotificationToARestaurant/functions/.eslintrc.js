module.exports = {
  env: {
    es6: true,
    node: true,
  },
  plugins: ["prettier"],

  parserOptions: {
    ecmaVersion: 2018,
  },
  extends: ["eslint:recommended", "google", "plugin:prettier/recommended"],
  rules: {
    "no-restricted-globals": ["error", "name", "length"],
    quotes: ["error", "double", { allowTemplateLiterals: true }],
  },
  overrides: [
    {
      files: ["**/*.spec.*"],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
  globals: {},
};
