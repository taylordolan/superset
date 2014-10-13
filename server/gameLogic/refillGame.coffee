@refillGame = (maxcards,game_id) ->
  if maxcards
    maxcards
  else
    maxcards = 12
  console.log('refill')
  in_play = Gamecards.find({game_id: game_id, status: 'playing'}, {sort: {order: 1}}).fetch()
  console.log("cards in play: " + in_play.length)
  if in_play.length < maxcards
    console.log(maxcards - in_play.length)

    for i in [0..(maxcards - in_play.length - 1)] by 1
      #console.log("index test: " + i)
      #console.log(in_play[i])
      if (cards_left = Gamecards.find({game_id: game_id, status: 'unused'}).count()) == 0
        Gamecards.update({game_id: game_id, status: 'matched'}, {$set: {status: 'unused'}}, {multi: true})
        cards_left = Gamecards.find({game_id: game_id,status: 'unused'}).count()
      R = Math.floor(Math.random() * cards_left)
      console.log('cards left ' + cards_left)
      gc = Gamecards.find({game_id: game_id, status: 'unused'},{limit: 1, skip: R}).fetch()
      Gamecards.update({game_id: game_id, _id: gc[0]._id, status:'unused'}, {$set: {status: 'playing'}},
        callback = (error,result) ->
          console.log("records affected: " + result)
          if result > 0
            affected = result
            console.log("added: " + affected)
      )
  in_play = Gamecards.find({game_id: game_id, status: 'playing'}).count()
  console.log("cards in play: " + in_play)
