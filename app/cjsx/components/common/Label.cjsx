# @cjsx React.DOM
React = require 'react'

Label = React.createClass
  getDefaultProps: ->
    lightClassName: ' fc-light'
    darkClassName: ' fc-dark'

  # hexToRgb taken from here:
  # http://stackoverflow.com/questions/5623838/rgb-to-hex-and-hex-to-rgb
  hexToRgb: (hex) ->
    result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec hex

    r: if result then parseInt(result[1], 16) else 255
    g: if result then parseInt(result[2], 16) else 255
    b: if result then parseInt(result[3], 16) else 255

  getColorLightness: (rgbObject) ->
    (rgbObject.r * 299 + rgbObject.g * 587 + rgbObject.b * 114) / 1000

  getFontColorClassName: (hex) ->
    lightness = @getColorLightness @hexToRgb(hex)
    if lightness > 125 then @props.darkClassName else @props.lightClassName

  getStyleObject: ->
    background: "##{@props.model.color}"

  render: ->
    classString = 'label f1 fw-light' + @getFontColorClassName(@props.model.color)

    <span className={classString} style={@getStyleObject()}>{@props.model.name}</span>

module.exports = Label
