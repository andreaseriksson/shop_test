module.exports = {
  purge: [
    './src/**/*.eex',
    './src/**/*.leex',
  ],
  plugins: [
    require('kutty'),
  ]
}
