const { environment } = require('@rails/webpacker')

const vue = require('vue')
const webpack = require('webpack')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jquery: 'jquery',
  jQuery: 'jquery',
  'window.jQuery': 'jquery',
  Popper: ['popper.js', 'default'],
  moment: 'moment'
}))
environment.loaders.prepend('vue', vue)
module.exports = environment
