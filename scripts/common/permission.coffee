_ = require 'lodash'

C = require './constants.coffee'

class Permission extends require './core/base.coffee'
  # ユーザーグループ
  group: {}

  # コンストラクタ
  constructor: ->
    super()

    # 権限グループを作成する
    _.forEach C.PERMISSION, (name) =>
      @group[name] = []

module.exports = new Permission()