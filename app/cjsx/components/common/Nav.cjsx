# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'

AppHeader = require './AppHeader'
Button = require './Button'

Nav = React.createClass

  mixins: [Router.State, Router.Navigation]

  componentWillReceiveProps: ->
    @setState currentPage: @getParams().page

  getInitialState: ->
    currentPage: @getParams().page

  handleChange: (event) ->
    @setState currentPage: event.target.value

  handleKeyDown: (event) ->
    targetPage = parseInt(event.target.value)
    if event.keyCode is 13 and typeof targetPage is 'number'
      @transitionTo @getRoutes()[1].path.replace(':page', targetPage)

  render: ->
    <AppHeader>
      <div className='item-1 container-flex-row'>

        <div className='item-1 container-flex-row justify-start'>
          <Button className='item-1 margin-xs button-nav' text='Prev' handler={@props.prev} disable={@props.links.prev}/>
          <Button className='item-1 margin-xs button-nav' text='Next' handler={@props.next} disable={@props.links.next}/>
        </div>

        <div className='item-1 f2 container-flex-row justify-end align-center padding-sides fc-light'>
          <div>
            page <input type='text' className='fc-dark' value={@state.currentPage} onChange={@handleChange} onKeyDown={@handleKeyDown}/> of {@props.last}
          </div>
        </div>

      </div>
    </AppHeader>

module.exports = Nav
