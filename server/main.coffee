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
  refill_game(12,game)
  Meteor.methods
    dummy: ->
      return 'hi dummy'
    set: (game_id = 0,cards) ->
      c = Cards.find({_id: {$in: cards}}).fetch()
      gc = Gamecards.find({game_id: game, card_mid: {$in: cards}, status: 'playing'}).fetch()
      console.log(cards)
      console.log(c)
      if cards.length == 3 && c.length == 3 && gc.length == 3
        N = 0
        C = 0
        SD = 0
        SP = 0
        (N += card.number; C += card.color; SD += card.shade; SP += card.shape) for card in c
        if ((N % 3 == 0) && (C % 3 == 0) && (SD % 3 == 0) && (SP % 3 == 0))
          console.log("VALID SET")
          console.log(cards)
          Gamecards.update({game_id: game_id, card_mid: {$in: cards}, status: 'playing'}, {$set: {status: 'matched'}},{multi: true})
          Statistics.update({game: game_id}, {$inc: {sets_found: 1}})
          refill_game(12,game_id)
      else
        message = 'Wrong number of cards'
    SUset: (game_id = 0,cards,iso = 0) ->
      console.log('game_id ' + game_id)
      cardcount = Gamecards.find({game_id: game_id, card_mid: {$in: cards}}).count()
      console.log(cardcount)
      if cardcount != 6
        return 'Wrong number of cards'
      pairings = []
      if false
        n = 0
        for C1 in cards
          n++
          n2 = 0
          for C2 in cards
            n2++
            if n2 > n
              pairings.push([C1,C2])

        SUSs = []
        n = 0
        for S1 in pairings
          n++
          n2 = 0
          for S2 in pairings
            n2++
            if S1[0] != S2[0] && S1[0] != S2[1] && S1[1] != S2[1] && S1[1] != S2[0] && n2 > n
              n3 = 0
              for S3 in pairings
                n3++
                if S2[0] != S3[0] && S2[0] != S3[1] && S2[1] != S3[0] && S2[1] != S3[1] && S1[0] != S3[0] && S1[0] != S3[1] && S1[1] != S3[0] && S1[1] != S3[1] && n3 > n2
                  SUSs.push([S1,S2,S3])
      else
        SUSs = [[[cards[0],cards[1]],[cards[2],cards[3]],[cards[4],cards[5]]]]
      i = 0
      for SUS in SUSs
        console.log(SUS)
        derived_set = []
        for pairing in SUS
          #console.log(pairing)
          c = Cards.find({_id: {$in: pairing}}).fetch()
          N = 0
          C = 0
          SD = 0
          SP = 0
          for card in c
            N = N + card.number
            C = C + card.color
            SD = SD + card.shade
            SP = SP + card.shape
            #console.log(card.number + ':' + card.color + ':' + card.shade + ':' + card.shape)
          N3 = card_lookup[N]
          C3 = card_lookup[C]
          SD3 = card_lookup[SD]
          SP3 = card_lookup[SP]
          derived_set.push([N3,C3,SD3,SP3])
        if iso == 1
          unless derived_set[0].equals(derived_set[1]) && derived_set[0].equals(derived_set[2])
            derived_set = []
        N = 0
        C = 0
        SD = 0
        SP = 0
        console.log(derived_set)
        for card in derived_set
          N += card[0]
          C += card[1]
          SD += card[2]
          SP += card[3]
        #console.log(N + ':' + C + ':' + SD + ':' + SP)
        if ((N % 3 == 0) && (C % 3 == 0) && (SD % 3 == 0) && (SP % 3 == 0) && derived_set.length > 0)
          i++
          console.log('VALID SUS')
      if i > 0
        Gamecards.update({game_id: game_id, card_mid: {$in: cards}, status: 'playing'}, {$set: {status: 'matched'}}, {multi: true})
        refill_game(12,game_id)
        if iso == 0
          Statistics.update({game: game_id}, {$inc: {superunknown_found: 1}})
          message = 'Valid Super Unknown Set!'
        else
          Statistics.update({game: game}, {$inc: {isosuperunknown_found: 1}})
          message = 'Valid Isometric Super Unknown Set!'
      else
        if iso == 0
          message = 'Not a valid Super Unknown Set'
        else
          message = 'Not a valid Isometric Super Unknown Set (selection order matters)'
      return message

    check_sets: (game_id) ->
      unless game_id
        game_id = 0
      check_for_sets(game_id)
