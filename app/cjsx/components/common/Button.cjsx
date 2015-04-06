# @cjsx React.DOM
React = require 'react'
joinClasses = require 'react/lib/joinClasses'

Button = React.createClass
  render: ->
    disabledClass = if @props.disable then '' else ' disabled'

    <button className={joinClasses(@props.className, disabledClass)} onClick={@props.handler}>
      {@props.text}
    </button>

module.exports = Button
