redis = require 'redis'
data = redis.createClient()

module.exports =
  # redisサーバからデータを取得する。非同期処理なのでコールバックが必要
  # @param key String データのキー
  # @return Promiseオブジェクトを返す
  getData: (key) ->
    new Promise (resolve) =>
      data.get key, (err, reply) ->
        # エラーが起きた場合はスローする
        if err
          throw err
          return resolve null

        # データが存在していない場合はundefinedを返す
        unless reply
          return resolve undefined

        # データが存在していた場合は、値を返す
        return resolve reply

  # redisサーバにデータを保存する
  # @param key String データのキー
  # @param value String データの値
  # @return データを保存できたかどうか
  setData: (key, value) ->
    data.set key, value, (err, keys_replies) ->
      # エラーが起きた場合はスローする
      if err
        throw err
        return false
