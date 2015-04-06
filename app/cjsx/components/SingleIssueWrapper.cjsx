# @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
{Link} = Router

IssueDescription = require './common/IssueDescription'
Button = require './common/Button'
ApiUtils = require '../utils/ApiUtils'
Label = require './common/Label'
AppHeader = require './common/AppHeader'

SingleIssueWrapper = React.createClass

  mixins: [Router.State, Router.Navigation]

  getInitialState: ->
    baseUrl: 'https://api.github.com/repos/rails/rails/issues'
    issueId: @getParams().id

  componentDidMount: ->
    @getIssue @state.issueId

  getIssue: (id) ->
    ApiUtils.getSingleIssue id
    .done (newState) =>
      @setState newState
      @getComments newState.issue.comments_url if newState.issue.comments

  getComments: (url) ->
    ApiUtils.getComments url
    .done (newState) =>
      @setState newState

  navigateBack: ->
    if not @goBack()
      @transitionTo '/issues/1'

  # Running out of time here, DRYing this up into reusable components would be my #1 focus...
  render: ->
    <div className='container-flex-col'>
      <AppHeader>
        <div className='item-1 container-flex-row justify-start'>
          <Button className='item-1 margin-xs button-nav' text='Back To Issue' handler={@navigateBack} disable={true}/>
        </div>
      </AppHeader>
      {
        if @state.issue
          issue = @state.issue
          <div>

            <div className='container-flex-row issue single margin-bottom'>
              <img className='single-image' src={issue.user.avatar_url}/>
              <div className='container-flex-col padding-sides align-center item-1'>

                <div className='item-3 f1-5 v-center bold'>
                  <Link to="/issue/#{issue.number}"> #{issue.number} [{issue.state}] : {issue.title}</Link>
                </div>

                <div className='item-1 v-center margin-bottom'>
                  <div className='container-flex-row item-1'>
                    {<Label model={label} key={label.name}/> for label in issue.labels}
                  </div>
                </div>
              </div>
            </div>

            <IssueDescription data={issue}/>

          </div>
      }
       {
        if @state.comments
          <div className='margin-bottom'>
            <AppHeader>
              <div className='item-1 v-center fc-light bold justify-center'>
                Comments...
              </div>
            </AppHeader>
            {<IssueDescription data={comment} key={comment.id}/> for comment in @state.comments}
          </div>
      }
    </div>

module.exports = SingleIssueWrapper
