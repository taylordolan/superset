@card_lookup = [0,2,1,0,2]
@game = 0

Meteor.startup ->
  refill_game(12)
  Meteor.methods
    dummy: ->
      return 'hi dummy'
    set: (cards) ->
      c = Cards.find({_id: {$in: cards}}).fetch()
      gc = Gamecards.find({card_mid: {$in: cards}, status: 'playing'}).fetch()
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
          Gamecards.update({game_id: game, card_mid: {$in: cards}, status: 'playing'}, {$set: {status: 'matched'}},{multi: true})
          Statistics.update({game: 0}, {$inc: {sets_found: 1}})
          refill_game(12)
    SUset: (cards) ->
      pairings = []
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
      i = 0
      for SUS in SUSs
        #console.log(SUS)
        derived_set = []
        for pairing in SUS
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
        N = 0
        C = 0
        SD = 0
        SP = 0
        for card in derived_set
          N += card[0]
          C += card[1]
          SD += card[2]
          SP += card[3]
        #console.log(N + ':' + C + ':' + SD + ':' + SP)
        if ((N % 3 == 0) && (C % 3 == 0) && (SD % 3 == 0) && (SP % 3 == 0))
          i++
          console.log('VALID SUS')
          console.log(derived_set)
      console.log(i)
      if i > 0
        Gamecards.update({game_id: game, card_mid: {$in: cards}, status: 'playing'}, {$set: {status: 'matched'}}, {multi: true})
        Statistics.update({game: 0}, {$inc: {superunknown_found: 1}})
        refill_game(12)
        message = 'Valid Super Unknown Set!'
      else
        message = 'Not a valid Super Unknown Set'
      return message



    check_sets: (game) ->
      unless game
        game = 0
      check_for_sets()
