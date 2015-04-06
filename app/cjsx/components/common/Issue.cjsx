  # @cjsx React.DOM
React = require 'react'
Router = require 'react-router'
{Link} = Router

Label = require './Label'

Issue = React.createClass

  render: ->
    issue = @props.model

    <div className={@props.className}>
      <div>
        <img className='table-image' src={issue.user.avatar_url}/>
      </div>

      <div className='item-4 container-flex-col padding-sides'>
        <div className='item-3 f1-5 v-center bold'>
          <Link to="/issue/#{issue.number}"> #{issue.number} : {issue.title}</Link>
        </div>

        <div className='item-3 fw-light container-flex-col margin-bottom align-start'>
          <div className='margin-top margin-bottom'>
            <span><a href={issue.user.html_url}>{issue.user.login}</a>:</span>
          </div>
          {
            innerHtml = if @props.truncate then issue.body.truncatedHtml else issue.body.html
            <div className='item-1'>
              <span dangerouslySetInnerHTML={ __html: innerHtml}/>
            </div>
          }
        </div>

        <div className='item-1 v-center margin-bottom'>
          <div className='container-flex-row item-1'>
            {<Label model={label} key={label.name}/> for label in issue.labels}
          </div>
        </div>
      </div>

    </div>

module.exports = Issue
