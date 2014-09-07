Meteor.startup ->
  refill_game(12)
  Meteor.methods
    dummy: ->
      return 'hi dummy'
    set: (cards) ->
      game = 0
      c = Cards.find({_id: {$in: cards}}).fetch()
      gc = Gamecards.find({card_mid: {$in: cards}, status: 'playing'}).fetch()
      console.log(cards)
      console.log(c)
      if cards.length = 3 && c.length == 3 && gc.length == 3
        N = 0
        C = 0
        SD = 0
        SP = 0
        (N = N + card.number; C = C + card.color; SD = SD + card.shade; SP = SP + card.shape) for card in c
        if ((N % 3 == 0) && (C % 3 == 0) && (SD % 3 == 0) && (SP % 3 == 0))
          console.log("VALID SET")
          Gamecards.update({game_id: game, card_mid: card._id, status: 'playing'}, {$set: {status: 'matched'}}) for card in c
          Statistics.update({game: 0}, {$inc: {sets_found: 1}})
          refill_game(12)
    check_sets: (game) ->
      unless game
        game = 0
      check_for_sets()
