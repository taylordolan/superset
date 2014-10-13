@card_lookup = [0,2,1,0,2]
@game = 0

Array.prototype.equals = (array) ->
  if !array
    return false;

  if (this.length != array.length)
    return false;

  i = 0
  for thing in this
    if (this[i] instanceof Array && array[i] instanceof Array)
      if (!this[i].equals(array[i]))
        return false
    else if (this[i] != array[i])
      return false
    i++
  return true

Meteor.startup ->
  _dummyCollection_ = new Meteor.Collection '__dummy__'
  refillGame(12,game)
  Meteor.methods
    dummy: ->
      return 'hi dummy'
    check_sets: (game_id) ->
      unless game_id
        game_id = 0
      check_for_sets(game_id)
