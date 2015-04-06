# @cjsx React.DOM
React = require 'react'
parseLinks = require 'parse-links'
$ = require 'jquery'
Router = require 'react-router'
{Route, RouteHandler, Link, DefaultRoute, Redirect} = Router

IssuesWrapper = require './components/IssuesWrapper'
SingleIssueWrapper = require './components/SingleIssueWrapper'

App = React.createClass
  render: ->
     <div className='container'>
        <RouteHandler/>
    </div>

routes =
  <Route handler={App}>
    <Redirect from='/' to='/issues/1'/>
    <Route path="/issues/:page" handler={IssuesWrapper}/>
    <Route path="/issue/:id" handler={SingleIssueWrapper}/>
  </Route>

Router.run routes, Router.HistoryLocation, (Handler) ->
  React.render <Handler/>, document.body
