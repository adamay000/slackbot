_ = require 'lodash'

speak = require './speak.coffee'
C = require './constants.coffee'

class Command extends require './core/base.coffee'
  # すべてのコマンド
  commands: []

  # コマンドを追加する
  # @param commandNames String コマンド名
  # @param options Object オプション設定
  # @param commandNames Array コマンド名の配列
  # @param fn function コマンド要求時に実行する関数
  add: (commandNames, options, fn) ->
    # options:
    #   help       String  ヘルプ用のテキスト
    #   permission String  コマンドを使うために必要な権限
    #   finish     Boolean 最初にヒットしたコマンドのみ実行して以降マッチさせない
    #   noHelp     Boolean ヘルプに登録するかどうか(エイリアス用)
    unless _.isArray commandNames
      @_add commandNames, options, fn
    else
      _.forEach commandNames, (commandName) =>
        @_add commandName, options, fn
        options.noHelp = true

  # コマンドを追加する
  # @param commandName String コマンド名
  # @param options Object オプション設定
  # @param fn function コマンド要求時に実行する関数
  _add: (commandName, options = {}, fn) ->
    unless options?.noHelp
      @commands.push
        name: commandName
        help: options?.help or ''
        fn: fn
    # !commandのようにprefixを追加する
    # ( +.*|$)によって!command2のようにスペース以外の文字が続くコマンドを弾く
    regx = new RegExp "^#{C.COMMAND.PREFIX}#{commandName}( +.*|$)"
    # TODO: robot.hearだとDMに反応できないっぽい？robot.recieveで!から始まる発言を取得すればよさそう？
    @robot.hear regx, (res) ->
      # デフォルトで加入している#generalには反応させない
      if _.includes C.COMMAND.BLACKLIST, res.message.room
        return

      # TODO: res.message.user.idとoptions.permissionを使って権限の有無でコマンド実行できるかどうか決めたい

      # 必要な情報だけ抜き出してコールバックに渡してやる
      param =
        command: res.match[0]
        message: res.match[1]
        room: res.message.room
        userId: res.message.user.id
        userName: res.message.user.name

      fn param
      # 強制終了フラグがあれば、以降マッチするコマンドを無視する
      if options?.finish
        res.finish()

  # 辞書型で定義されたコマンドとその引数をパースして実行する
  # @param param Object ユーザの発言パラメータ
  # @param commands Object コマンドのオブジェクト
  execute: (param, commands) ->
    @_execute param.message, param, commands, [], [param.command]

  # 再帰用: 辞書型で定義されたコマンドとその引数をパースして実行する
  # @param message String 残っているメッセージ
  # @param param Object ユーザの発言パラメータ
  # @param commands Object コマンドのオブジェクト
  # @param stackedArgs Array _numberなどで保持している実行時に渡す引数
  # @param stackedCommandName Array ヘルプ用に保持するコマンド名
  _execute: (message, param, commands, stackedArgs, stackedCommandName) ->
    # TODO: どこかしらで権限をチェックしたい

    # _defaultを持っていない場合は実行部分まで辿り着いているので実行して終了する
    unless commands?._default
      return commands?.fn stackedArgs.concat(message)

    # 引数に分解する
    args = message.trim().split C.COMMAND.SPLIT

    # それ以上引数が存在していなければ_defaultを探して実行する
    unless args.length
      return commands?._default?.fn stackedArgs

    # 引数が一つでもあればマッチするコマンドを探す
    nextCommands = false
    _.forEach commands, (value, commandName) ->
      # _numberのように特殊な引数は個別にチェックする

      # 引数が数値なら
      if commandName is '_number'
        arg = parseInt(args[0])
        unless isNaN arg
          stackedArgs.push arg
          return nextCommands = value

      # マッチするコマンドがあればフラグを立ててループを抜ける
      if args[0] is commandName
        return nextCommands = value

    # マッチするコマンドで再帰処理する
    if nextCommands
      # コマンド名を保存する
      stackedCommandName.push args[0]
      # コマンド名を省くことで次の引数を渡す
      nextMessage = args.slice(1).join(C.COMMAND.SPLIT)
      @_execute nextMessage, param, nextCommands, stackedArgs, stackedCommandName
    else
      # どれにもマッチしなければ_defaultを実行する
      # _defaultがfnを持っていない場合は引数一覧を表示する
      (commands?._default?.fn or () ->
        help = []
        # コマンドのhelpを一つずつ見ていく
        _.forEach commands, (value, commandName) ->
          if value.help
            name = commandName
            name = '[Number]' if commandName is '_number'
            help.push "#{_.flatten([stackedCommandName, name]).join(C.COMMAND.SPLIT)}: #{value.help}"
        # 一つでもコマンドがあればヘルプメッセージを送信する
        if help.length
          speak.private param.userName, help.join('\n')
        ) stackedArgs.concat(message)

  # コマンドの一覧を取得する
  # @return Array コマンド名の一覧
  list: ->
    @commands


module.exports = new Command()