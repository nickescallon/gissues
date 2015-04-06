# @cjsx React.DOM
React = require 'react'

IssueDescription = React.createClass
  render: ->
    model = @props.data
    <div className='description' dangerouslySetInnerHTML={ __html: model.body.html}/>

    <div className='item-1 container-flex-col description f1-5'>

      <div className='item-3 fw-light container-flex-col margin-bottom align-start'>
        <div className='margin-top margin-bottom'>
          <span><a href={model.user.html_url}>{model.user.login}</a>:</span>
        </div>
        {
          innerHtml = if @props.truncate then model.body.truncatedHtml else model.body.html
          <div className='item-1 width-full wrap'>
            <span dangerouslySetInnerHTML={ __html: innerHtml}/>
          </div>
        }
      </div>

    </div>

module.exports = IssueDescription
