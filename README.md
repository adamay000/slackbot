# BOT

# Get started

```sh
$ npm install
$ sudo apt-get redis-server
$ chown +x server.sh
$ chown +x run.sh
$ touch token
# edit token
$ ./server.sh
$ ./run.sh
```

# Structure

```
+/
  + scripts/
    + common/
      + core/
        - base.coffee          # /scripts/common/の直下の基礎機能の継承元
        - module.coffee        # /scripts/の直下の拡張機能の継承元
      + include/
        - get-user-id.coffee   # slackの名前->ID変換
        - get-user-name.coffee # slackのID->名前変換
        - redis.coffee         # redisサーバとの読み書き

      - command.coffee         # コマンドの追加とか実行とか
      - constants.coffee       # 定数
      - group.coffee           # ユーザのグループ作りたい
      - permission.coffee      # ユーザ毎の権限作りたい
      - speak.coffee           # 発言関連

    - _init.coffee             # hubotのrobotを基礎機能からでも呼べるようにする
    - help.coffee              # コマンド一覧の表示
    - roulette.coffee          # ランダムなメンバー抽出する
    - test.coffee              # テスト用

  - run.sh                     # ボット動かす
  - server.sh                  # redis動かす
  - token                      # slackにつなぐためのトークン
```

# やりたい

- 天気予報。雨降りそうになる前にDMしたい
- googleカレンダー読んでDMでリマインド