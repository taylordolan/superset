@get_random_card = () ->
  # number = Math.floor((Math.random() * 3))
  # color = Math.floor((Math.random() * 3))
  # shade = Math.floor((Math.random() * 3))
  # shape = Math.floor((Math.random() * 3))
  # console.log("#{number} #{color} #{shade} #{shape}")
  # c = Cards.find({number: number, color: color, shade: shade, shape: shape, type: 'standard'})

  return c

@refill_game = (maxcards) ->
  if maxcards
    maxcards
  else
    maxcards = 12
  console.log('refill')
  in_play = Gamecards.find({status: 'playing'}).count()
  #console.log("cards in play: " + in_play)
  if in_play < maxcards
    console.log(maxcards - in_play)
    for i in [0..(maxcards - in_play - 1)] by 1
      if (cards_left = Gamecards.find({status: 'unused'}).count()) == 0
        Gamecards.update({game_id: game, status: 'matched'}, {$set: {status: 'unused'}}, {multi: true})
        cards_left = Gamecards.find({status: 'unused'}).count()
      console.log('cards left ' + cards_left)
      R = Math.floor(Math.random() * cards_left)
      console.log(cards_left)
      console.log(R)
      gc = Gamecards.find({status: 'unused'},{limit: 1, skip: R}).fetch()
      Gamecards.update({game_id: game, _id: gc[0]._id, status:'unused'}, {$set: {status: 'playing'}},
        callback = (error,result) ->
          console.log("records affected: " + result)
          if result > 0
            affected = result
            console.log("added: " + affected)
      )
  in_play = Gamecards.find({status: 'playing'}).count()
  console.log("cards in play: " + in_play)


@check_for_sets = () ->
  console.log('checking for sets')
  gc = Gamecards.find({status: 'playing'})
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
      refill_game(15)
      Statistics.update({game: game}, {$inc: {no_sets_in_twelve: 1}})
      message = "Adding 3 cards to 12"
    else if c.length == 15
      refill_game(18)
      Statistics.update({game: game}, {$inc: {no_sets_in_fifteen: 1}})
      message = "Adding 3 cards to 15"
    else
      refill_game(12)
      console.log("too few cards " + c.length)
  else
    message = "There exist " + i + " sets."
  console.log(message)
  return message

  @
