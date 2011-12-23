# FYI: I have no clue how this really runs yet. 'Bash$ make test' doesn't really do anything.

Tests  = require './tests'
assert = require 'assert'
helper = Tests.helper()

require('../scripts/lighthouse') helper

danger = Tests.danger helper, (req, res, url) ->
  res.writeHead 200
  res.end JSON.stringify(
    responseData:
      results: [
        unescapedUrl: ""
      ]
  )

tests = [
  (msg) -> assert.equal "show me all lh projects", msg
  (msg) -> assert.equal "hubot show me lh project 88071", msg
  (msg) -> assert.equal "show me lh tickets for 88071", msg
  (msg) -> assert.equal "show me lh ticket 1 in 88071", msg
]

# run the async tests
danger.start tests, ->
  helper.receive 'hubot show me all lh projects'
  helper.receive 'hubot show me lh project 88071'
  helper.receive 'show me lh tickets for 88071'
  helper.receive 'show me lh ticket 1 in 88071'
  helper.stop()

