# Description:
#   Type !help to see all available commands!

command = require './common/command.coffee'
group = require './common/group.coffee'
speak = require './common/speak.coffee'
C = require './common/constants'

_ = require 'lodash'

class Help extends require './common/core/module.coffee'
  @extend require './common/include/redis.coffee'

  constructor: ->
    command.add ['help', 'h'], {
      help: '実行可能なコマンド一覧を表示する'
      permission: C.PERMISSION.DEFAULT
    }, @help

  # ヘルプコマンド
  @help: (param) ->
    # TODO: command.list(userName)で名前を送ってその人が使うことのできるコマンドを表示させたい

    commands = []
    _.forEach command.list(), (val) ->
      commands.push "#{C.COMMAND.PREFIX}#{val.name}: #{val.help}"
    # チャンネルに送るとうるさいのでDMで送信する
    speak.private param.userName, commands.join('\n')

# 実際に呼び出される際にnewしてくれないので自身をbindする必要がある
module.exports = Help.bind(Help)
