Meteor.methods
  setGhost: (game_id = 0,cards,iso = 0) ->
    console.log('processing ghost set for game: ' + game_id)
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
        console.log('Valid Ghost Set')
    if i > 0
      Gamecards.update({game_id: game_id, card_mid: {$in: cards}, status: 'playing'}, {$set: {status: 'matched'}}, {multi: true})
      refillGame(12,game_id)
      if iso == 0
        Statistics.update({game: game_id}, {$inc: {found_ghosts: 1}})
        result = 1
      else
        Statistics.update({game: game}, {$inc: {found_isoghosts: 1}})
        result = 1
    else
      result = 0

    return result
