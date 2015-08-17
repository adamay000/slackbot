# Description:
#   Give `robot` to each modules

command = require './common/command.coffee'
group = require './common/group.coffee'
permission = require './common/permission.coffee'
speak = require './common/speak.coffee'

# 各基礎モジュールにロボットを渡すだけ
class Init
  constructor: (robot) ->
    command.init robot
    group.init robot
    permission.init robot
    speak.init robot

module.exports = Init
