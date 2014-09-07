@shapes = ['diamond', 'oval', 'squiggle']
@colors = ['green', 'purple', 'red']
@shades = ['empty', 'shaded', 'solid']
@numbers = ['one', 'two', 'three']
@border = ['none', 'dashed', 'solid']

@one = 0
@green = 0
@empty = 0
@diamond = 0

@two = 1
@purple = 1
@shaded = 1
@oval = 1

@three = 2
@red = 2
@solid = 2
@squiggle = 2

@four = 3
@blue = 3
@angleshade = 3
@triangle = 3

@five = 4
@yellow = 4
@hatched = 4
@square = 4

if Statistics.find().count() == 0
  Statistics.insert({
    game: 0,
    sets_found: 0,
    no_sets_in_twelve: 0,
    no_sets_in_fifteen: 0
  })
  console.log('insert stats')


i = 0
if Cards.find().count() == 0
  (Cards.insert({
    card_id: i,
    name: number + ' ' + shade + ' ' + color + ' ' + shape,
    number: numbers.indexOf(number),
    color: colors.indexOf(color),
    shade: shades.indexOf(shade),
    shape: shapes.indexOf(shape),
    type: 'standard'
  }); i++) for number in numbers for color in colors for shade in shades for shape in shapes

if Gamecards.find().count() == 0
  global_standard_game_cards = Cards.find({type: 'standard'})
  global_standard_game_cards.forEach (card) ->
    Gamecards.insert({
      game_id: 0,
      card_id: card.card_id,
      card_mid: card._id,
      status: 'unused'
    })
