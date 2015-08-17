class Speak extends require './core/base.coffee'
  @include require './include/get-user-id.coffee'

#  MAX_TRY_TIMES = 10
#  RETRY_INTERVAL = 1000

  # チャンネルメッセージを送信する
  # @param roomName String 送信する部屋の名前
  # @param message String 送信するメッセージ
  room: (roomName, message) ->
    @robot.send {room: roomName}, message

  # プライベートメッセージを送信する
  # @param userName String 送信する相手のユーザネーム
  # @param message String 送信するメッセージ
  private: (userName, message) ->
    userID = @getUserID userName

    @robot.adapter.client.openDM userID
    @robot.send {room: userName}, message

    # ref: http://blog.manaten.net/entry/hubot-slack-dm
    # DMを送信するにはDMオブジェクトが作成されている必要がある
    # outdated?
    # robot.adapter.client.getDMByIDが常にfalseを返していて働いてない気がする
#    if @robot.adapter.client.getDMByID(userID)?
#      @robot.send {room: userName}, message
#    else
#      # DMオブジェクトを作成する
#      @robot.adapter.client.openDM userID
#
#      cnt = 1
#      do =>
#        callee = arguments.callee
#
#        # DMオブジェクトが作成されるまでループする
#        setTimeout =>
#          if cnt++ > MAX_TRY_TIMES
#            return
#
#          unless @robot.adapter.client.getDMByID(userID)?
#            console.log 'check again', +new Date
#            return callee()
#
#          console.log 'send!'
#          @robot.send {room: userName}, message
#        , RETRY_INTERVAL

module.exports = new Speak()