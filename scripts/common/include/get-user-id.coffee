module.exports =
  # ユーザネームをユーザIDに変換する
  # @param userName String ユーザネーム
  # @return String ユーザID
  getUserID: (userName) ->
    @robot.adapter.client.getUserByName(userName)?.id or ''