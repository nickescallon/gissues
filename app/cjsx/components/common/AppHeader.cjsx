# @cjsx React.DOM
React = require 'react'

AppHeader = React.createClass
  render: ->
    <div className='container-flex-row header margin-top margin-bottom'>
      {this.props.children}
    </div>

module.exports = AppHeader
