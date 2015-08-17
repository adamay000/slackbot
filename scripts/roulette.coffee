# Description:
#   Type !roulette to get a random result!

command = require './common/command.coffee'
group = require './common/group.coffee'
speak = require './common/speak.coffee'
C = require './common/constants'

_ = require 'lodash'

class Roulette extends require './common/core/module.coffee'
  @extend require './common/include/get-user-name.coffee'

  constructor: (@robot) ->
    command.add ['roulette', 'random', 'rand'], {
      help: 'ランダムな値を取得する'
      permission: C.PERMISSION.DEFAULT
    }, @roulette

  # ルーレット
  @roulette: (param) =>
    command.execute param, {
      channel:
        help: 'channelのメンバーからランダムなメンバーを選ぶ'
        permission: C.PERMISSION.DEFAULT
        _number:
          help: 'channelのメンバーからランダムなメンバーを指定した数だけ選ぶ'
          permission: C.PERMISSION.DEFAULT
          fn: (args) =>
            @sendRandomMemberFromChannel param.room, false, args[0]
        _default:
          help: 'channelのメンバーからランダムなメンバーを選ぶ'
          permission: C.PERMISSION.DEFAULT
          fn: =>
            @sendRandomMemberFromChannel param.room, false
      online:
        help: 'channelのオンラインメンバーからランダムなメンバーを選ぶ'
        permission: C.PERMISSION.DEFAULT
        _number:
          help: 'channelのオンラインメンバーからランダムなメンバーを指定した数だけ選ぶ'
          permission: C.PERMISSION.DEFAULT
          fn: (args) =>
            @sendRandomMemberFromChannel param.room, true, args[0]
        _default:
          help: 'channelのオンラインメンバーからランダムなメンバーを選ぶ'
          permission: C.PERMISSION.DEFAULT
          fn: =>
            @sendRandomMemberFromChannel param.room, true
      _number:
        help: '0~指定した数-1の値を選ぶ'
        permission: C.PERMISSION.DEFAULT
        fn: (args) =>
          speak.room param.room, ((Math.random() * args[0]) << 0) + ''
      _default:
        help: ''
        permission: C.PERMISSION.DEFAULT
    }

  # チャンネルのメンバーからランダムなメンバーを選んでチャンネルに送信する
  # @param room String チャンネルの名前
  # @param isOnline Boolean オンラインのメンバーのみを候補とするかどうか
  # @param amount Number 選ぶ人数
  @sendRandomMemberFromChannel: (room, isOnline, amount = 1) ->
    members = @robot.adapter.client.getChannelByName(room).members
    # オンラインメンバーのみの場合は、フィルタをかける
    if isOnline
      _.remove members, (userId) => @robot.adapter.client.users[userId].presence is C.CHANNEL.PRESENCE.AWAY

    # 候補者のIDを名前に変換する
    members = _.map members, (userId) => @getUserName userId

    speak.room room, "候補: [#{members.join(', ')}]\n結果: [#{_.sample(members, amount).join(', ')}]"

# 実際に呼び出される際にnewしてくれないので自身をbindする必要がある
module.exports = Roulette.bind(Roulette)
