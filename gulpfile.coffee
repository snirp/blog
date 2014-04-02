gulp = require 'gulp'
map = require 'map-stream'
open = require 'open'
indexer = require './indexer'
connect = require 'gulp-connect'

# Load plugins
$ = require('gulp-load-plugins')()

gulp.task('build', ->
  gulp.src('content/**/*.md')
    .pipe($.frontMatter({
      property: 'meta'
      remove: true
    }))
    .pipe($.marked())
    .pipe(map((file, cb) ->
      file.path = file.path.replace(/md$/, 'html')
      cb(null, file)
    ))
    # Remove date from URLs
    .pipe(map((file, cb) ->
      file.path = file.base + file.meta.url.slice(1) + "/index.html"
      cb(null, file)
    ))
    .pipe(indexer())
    .pipe(gulp.dest('public/'))
)

# Connect
gulp.task 'connect', connect.server({
  root: ['public']
  port: 9000,
  livereload: true
})

gulp.task 'serve', ['connect'], ->
  open("http://localhost:9000")

gulp.task 'default', ->
  gulp.start 'build'

gulp.task 'watch', ['build', 'connect', 'serve'], ->
  gulp.watch 'content/**/*.md', ['build']

  gulp.watch 'content/**/*.md', (event) ->
    gulp.src(event.path)
      .pipe(connect.reload())


## TODOs

# HTML server for serving static files
# Gulp watcher
# Copy other images/css/js files over (js/css concatenation will come later)
# Basic template for homepage + individual posts
