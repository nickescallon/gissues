# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'

Issue = require './common/Issue'
Nav = require './common/Nav'
ApiUtils = require '../utils/ApiUtils'

IssuesWrapper = React.createClass

  mixins: [Router.State, Router.Navigation]

  getInitialState: ->
    currentPage: @getParams().page
    lastPage: '...'
    issues: []
    links: {}
    isLoading: false

  componentDidMount: ->
    @getPage @state.currentPage

  componentWillReceiveProps: (obj, newProps) ->
    @getPage newProps.getCurrentParams().page

  getPage: (pageNumber) ->
    @setState isLoading: true
    if pageNumber < 1
      @transitionTo '/issues/1'
    else
      ApiUtils.getIssuesPage pageNumber
        .always (newState) =>
          newState.isLoading = false
          if newState.currentPage > newState.lastPage
            @transitionTo "/issues/#{newState.lastPage}"
          else
            @setState newState

  onNextPageClick: ->
    if @state.links.next and not @state.isLoading
      @transitionTo "/issues/#{parseInt(@state.currentPage) + 1}"

  onPrevPageClick: ->
    if @state.links.prev and not @state.isLoading
      @transitionTo "/issues/#{parseInt(@state.currentPage) - 1}"

  render: ->
    <div className='container-flex-col height-full'>
      <Nav next={@onNextPageClick} prev={@onPrevPageClick} last={@state.lastPage} links={@state.links}/>
      <div className='item-1 y-scroll x-hidden'>
        <div className='margin-bottom'>
          {<Issue className='container-flex-row issue' model={issue} truncate={true} key={issue.id}/> for issue in @state.issues}
        </div>
      </div>
    </div>

module.exports = IssuesWrapper
