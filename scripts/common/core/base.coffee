# ref. http://minghai.github.io/library/coffeescript/03_classes.html

moduleKeywords = ['extended', 'included']

class Base
  # robot
  robot: null

  # ロボットを保持する
  # @param robot Object ロボット
  init: (robot) ->
    @robot = robot

  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @[key] = value

    obj.extended?.apply(@)
    this

  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      @::[key] = value

    obj.included?.apply(@)
    this

module.exports = Base