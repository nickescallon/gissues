# @cjsx React.DOM
jest.dontMock '../cjsx/components/common/Label.cjsx'

React = require 'react/addons'
Label = require '../cjsx/components/common/Label.cjsx'
TestUtils = React.addons.TestUtils

describe 'label component', ->
  getProps = (color, name) -> color: color, name: name

  it 'displays its name', ->
    props = getProps(null, 'a label')
    label = TestUtils.renderIntoDocument <Label model={props}/>

    expect(label.getDOMNode().textContent).toEqual('a label')

  it 'adds a light color class if passed in color is dark', ->
    props = getProps('000000', null)
    label = TestUtils.renderIntoDocument <Label model={props}/>
    expect(label.getDOMNode().className).toContain('fc-light')

  it 'adds a dark color class if passed in color is light', ->
    props = getProps('FFFFFF', null)
    label = TestUtils.renderIntoDocument <Label model={props}/>
    expect(label.getDOMNode().className).toContain('fc-dark')
