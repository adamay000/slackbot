redis = require 'redis'
_ = require 'lodash'

# TODO: redis使って保存する
class Group extends require './core/base.coffee'
  # すべてのグループ
  groups: {}

  # 指定したグループに新しいメンバーを追加する。グループが存在しない場合は作成する
  # @param groupName String 追加先のグループ名
  # @param memberName String 追加するメンバー名
  # @return Array 指定したグループに現在所属しているメンバーの一覧
  addMember: (groupName, memberName) ->
    # グループが存在していない場合は、新しく追加する
    unless @groups[groupName]
      @groups[groupName] = []

    # メンバーがまだ追加されていない場合には、グループに追加する
    unless _.includes @groups[groupName], memberName
      @groups[groupName].push memberName

    # 処理後のグループを返す
    @groups[groupName]

  # 指定したグループからメンバーを削除する
  # @param groupName String メンバーを削除するグループ名
  # @param memberName String 削除するメンバー名
  # @return Boolean メンバーを削除できたかどうか
  removeMember: (groupName, memberName) ->
    # グループが存在していなければ失敗(false)を返す
    unless @groups[groupName]
      return false

    # グループにメンバーが所属していなければ失敗(false)を返す
    unless _.includes @groups[groupName], memberName
      return false

    # グループからメンバーを除外して成功(true)を返す
    _.remove @groups[groupName], (name) -> name is memberName
    return true

  # 指定したグループに所属するメンバーを取得する
  # @param groupName String取得したいグループ名
  # @return Array 指定したグループに現在所属しているメンバーの一覧
  getMember: (groupName) ->
    group = @groups[groupName]
    # グループが存在していなければ空配列を返す
    unless group
      return []

    group

module.exports = new Group()