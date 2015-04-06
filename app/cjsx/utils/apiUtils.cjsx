$ = require 'jquery'
parseLinks = require 'parse-links'
ghm = require 'github-flavored-markdown'

BASE_URL = 'https://api.github.com/repos/rails/rails/issues'

# Check if ETag has changed, if so, fetch the new data, else, load it from cache
getFromCacheOrApi = (url, callback) ->
  d = $.Deferred()
  cache = JSON.parse localStorage.getItem(url)

  options =
    url: url
    type: 'GET'
    headers: if cache then {'If-None-Match': cache.eTag} else null

  $.ajax options
  .done (response, status, jqXHR) ->
    if status is 'notmodified'
      d.resolve cache
    else
      transformed = callback.apply @, arguments
      localStorage.setItem url, JSON.stringify(transformed)
      d.resolve transformed

  d.promise()

escapeHtml = (string) ->
  pre = document.createElement 'pre'
  text = document.createTextNode string
  pre.appendChild text
  pre.innerHTML

truncate = (text) ->
  if text.length > 140 then text.substr(0,140).replace(/[ ][^ ]*$/ , ' ...') else text

linkMentions = (text) ->
  escaped = escapeHtml text
  linkified = escaped.replace /(^@\w+)|([ ]@\w+)/gmi, (match) ->
    userName = match.replace('@', '').replace(' ', '')
    "<a href='https://github.com/#{userName}'>#{match}</a>"
  "<span>#{linkified}</span>"

transform = (response) ->
  for item in response
    transformedBody =
      truncatedHtml: linkMentions truncate(item.body)
      html: ghm.parse linkMentions(item.body), 'rails/rails'
    item.body = transformedBody
  response

# TODO: DRY these handlers, requires changes in how app assumes response structure
pageHandler = (response, status, jqXHR) ->
  issues: transform response
  links: parseLinks(jqXHR.getResponseHeader('Link') or '')
  eTag: jqXHR.getResponseHeader('eTag')

issueHandler = (response, status, jqXHR) ->
  issue: transform([response])[0]
  eTag: jqXHR.getResponseHeader('eTag')

commentHandler = (response, status, jqXHR) ->
  comments: transform response
  eTag: jqXHR.getResponseHeader('eTag')

getIssuesPage = (pageNumber) ->
  d = $.Deferred()

  getFromCacheOrApi "#{BASE_URL}?page=#{pageNumber}&per_page=25", pageHandler
  .done (pageObject) ->
    pageObject.lastPage = if pageObject.links.last then pageObject.links.last.match(/page=(\d+)/)[1] else pageNumber
    pageObject.currentPage = parseInt(pageNumber)
    d.resolve pageObject
  .fail d.reject

  d.promise()

getSingleIssue = (id) ->
  getFromCacheOrApi "#{BASE_URL}/#{id}", issueHandler

getComments = (url) ->
  getFromCacheOrApi url, commentHandler

# Exposing some private methods for testability
module.exports =
  getSingleIssue: getSingleIssue
  getComments: getComments
  getIssuesPage: getIssuesPage
  _transform: transform
  _truncate: truncate
  _linkMentions: linkMentions
