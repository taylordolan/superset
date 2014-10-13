@game = 0

@get_random_card = () ->
  # number = Math.floor((Math.random() * 3))
  # color = Math.floor((Math.random() * 3))
  # shade = Math.floor((Math.random() * 3))
  # shape = Math.floor((Math.random() * 3))
  # console.log("#{number} #{color} #{shade} #{shape}")
  # c = Cards.find({number: number, color: color, shade: shade, shape: shape, type: 'standard'})
  return c

@get_distinct_order = (game_id) ->
  r = Gamecards.find({game_id: game_id, status: 'playing'}, {sort: {order: 1}}).fetch()
  ordering = []
  i = 0
  # for card in r
  #   if card.order =



@check_for_sets = (game_id) ->
  console.log('checking for sets')
  gc = Gamecards.find({game_id: game_id, status: 'playing'})
  cardIds = gc.map( (c) -> return c.card_mid )
  c = Cards.find({_id: {$in: cardIds}}).fetch()
  i = 0
  n = 0
  for card1 in c
    n++
    n2 = 0
    for card2 in c
      n2++
      n3 = 0
      if n2 > n && n2 < c.length
        for card3 in c
          n3++
          if n3 > n2
            console.log(n + ' - ' + n2 + ' - ' + n3)
            if card1 != card2 && card2 != card3 && card1 != card3
              N = card1.number + card2.number + card3.number
              C = card1.color + card2.color + card3.color
              SD = card1.shade + card2.shade + card3.shade
              SP = card1.shape + card2.shape + card3.shape
              if ((N % 3 == 0) && (C % 3 == 0) && (SD % 3 == 0) && (SP % 3 == 0))
                i++
  console.log("sets: " + i)
  if i == 0
    if c.length == 12
      refillGame(15,game_id)
      Statistics.update({game: game_id}, {$inc: {no_sets_in_twelve: 1}})
      message = "Adding 3 cards to 12"
    else if c.length == 15
      refillGame(18,game_id)
      Statistics.update({game: game_id}, {$inc: {no_sets_in_fifteen: 1}})
      message = "Adding 3 cards to 15"
    else
      refillGame(c.length+1,game_id)
      console.log("adding just one card" + c.length)
  else
    p = ''
    n = ''
    if i > 1
      p = 's'
    else
      n = 's'
    message = i + " normal set" + p + " exist" + n + "."
  console.log(message)
  return message
