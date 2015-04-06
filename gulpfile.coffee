browserify = require 'browserify'
concat = require 'gulp-concat'
del = require 'del'
express = require 'express'
gulp = require 'gulp'
mainBowerFiles = require 'main-bower-files'
reactify = require 'coffee-reactify'
source = require 'vinyl-source-stream'
spawn = require('child_process').spawn

sources =
  cjsx:
    app: ['./app/cjsx/App.cjsx']
    all: ['./app/cjsx/**/*.cjsx']
  css: ['./app/css/**/*.css']
  index: ['./app/index.html']

destinations =
  js: './dist/js'
  css: './dist/css'
  index: './dist/'

# NOTE: For a production setup, I'd minify the concatted source/css
# using gulp-uglify and gulp-minifyCss
gulp.task 'cjsx:app', ->
  browserifyOptions =
    entries: sources.cjsx.app
    extensions: ['.cjsx']

  browserify browserifyOptions
    .transform reactify
    .bundle()
    .pipe source('app.js')
    .pipe gulp.dest(destinations.js)

gulp.task 'css', ->
  cssSource = mainBowerFiles('**/*.css').concat sources.css

  gulp.src cssSource
    .pipe concat('app.css')
    .pipe gulp.dest(destinations.css)

gulp.task 'index', ->
  gulp.src sources.index
    .pipe gulp.dest(destinations.index)

gulp.task 'server', ->
  app = express()
  port = process.env.PORT || 3000
  app.use '/',  express.static(__dirname + '/dist')
  app.get '*', (req, res) -> res.sendFile(__dirname + '/dist/index.html')
  app.listen port, -> console.log('app listenting on port: ' + port)

gulp.task 'watch', ->
  gulp.watch sources.cjsx.all, ['cjsx:app']
  gulp.watch sources.css, ['css']
  gulp.watch sources.index, ['index']

gulp.task 'build', [
  'cjsx:app'
  'css'
  'index'
]

gulp.task 'dev', ['build', 'watch', 'server']

gulp.task 'default', ['build', 'server']
