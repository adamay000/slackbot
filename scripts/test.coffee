# Description:
#   Test

command = require './common/command.coffee'
speak = require './common/speak.coffee'

class Test extends require './common/core/module.coffee'
  @extend require './common/include/redis.coffee'

  constructor: ->

#    command.add ['set'], {
#      help: 'test data set'
#      permission: C.PERMISSION.OWNER
#    }, @set
#
#    command.add ['get'], {
#      help: 'test data get'
#      permission: C.PERMISSION.OWNER
#    }, @get

  # redisにデータを保存する
  @set: (res) ->
    if @setData key, value
      res.send 'Successfully set `#{value}` as `#{key}`.'
    else
      res.send 'Failed to set `#{value}` as `#{key}`.'

  # redisからデータを取得する
  @get: (res) =>
    key = res.match[1].trim()
    if key
      @getData(res.match[1]).then (val) =>
        console.log "getData('#{res.match[1]}'): #{val}"

# 実際に呼び出される際にnewしてくれないので自身をbindする必要がある
module.exports = Test.bind(Test)