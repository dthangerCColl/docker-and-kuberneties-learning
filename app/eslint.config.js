module.exports = [
  {
    // What files to lint
    files: ["**/*.js"],

    // Ignore node_modules
    ignores: ["node_modules/**"],

    // Environment settings - tells ESLint what globals exist
    languageOptions: {
      ecmaVersion: 2020,
      sourceType: "commonjs",
      globals: {
        // Node.js globals
        require: "readonly",
        module: "readonly",
        process: "readonly",
        __dirname: "readonly",
        console: "readonly"
      }
    },

    // The rules - start with basics, add more as needed
    rules: {
      "no-unused-vars": "warn",        // Warn about unused variables
      "no-undef": "error",             // Error on undefined variables
      "no-console": "off",             // Allow console.log (fine for servers)
      "semi": ["warn", "always"],      // Warn if missing semicolons
      "eqeqeq": "warn"                 // Warn to use === instead of ==
    }
  }
];
