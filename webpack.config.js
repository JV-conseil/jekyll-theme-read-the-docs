const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
  entry: {
    theme: ["./assets/js/theme.js", "./_sass/theme.scss"],
  },
  output: {
    filename: "js/[name].min.js",
    path: path.resolve(__dirname, "assets"),
  },
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: "css-loader",
            options: {
              url: false,
            },
          },
          {
            loader: "sass-loader",
            options: {
              sassOptions: {
                // Silences deprecation warnings from node_modules / dependencies
                quietDeps: true,
                // Optional: silence specific deprecation types globally
                silenceDeprecations: [
                  "import",
                  "slash-div",
                  "global-builtin",
                  "legacy-js-api",
                ],
              },
            },
          },
        ],
      },
      {
        test: /\.js$/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env"],
          },
        },
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: "css/[name].min.css",
    }),
  ],
};
