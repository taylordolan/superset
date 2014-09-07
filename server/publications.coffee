Meteor.publish('cards', () ->
  return Cards.find()
)
Meteor.publish('gamecards', () ->
  return Gamecards.find()
)
Meteor.publish('games', () ->
  return Games.find()
)
Meteor.publish('statistics', () ->
  return Statistics.find()
)
