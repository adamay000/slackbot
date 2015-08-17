module.exports =
  # ユーザIDをユーザネームに変換する
  # @param userId String ユーザID
  # @return String ユーザネーム
  getUserName: (userId) ->
    @robot.adapter.client.getUserByID(userId)?.name or ''