introset = []

Template.instructions.events
  'click .intro-card': (e, template) ->
    e.preventDefault();
    console.log('clicked intro card')
    console.log(e.target.id)
    if ($(e.target).hasClass('intro-selected'))
      $(e.target).removeClass('intro-selected')
      i = 0
      match = 0
      for card in introset
       if (card == e.target.id)
         match = i
       i++
      introset.splice(match,1)
    else
      if ($('.intro-card.intro-selected').length < Session.get("selection-limit"))
        $(e.target).addClass('intro-selected')
        introset.push(e.target.id)

    console.log('intro-selected cards ' + $('.intro-card.intro-selected').length)
    for card in introset
      console.log(card)
    if Session.get("selection-type") == "normal"
      if ($('.intro-card.intro-selected').length == 3)
        N = 0
        C = 0
        SD = 0
        SP = 0
        (N = N + card.number; C = C + card.color; SD = SD + card.shade; SP = SP + card.shape) for card in introset
        delay = 3500
        delay_increment = 750
        if (N % 3 == 0)
          v_number = true
        else
          v_number = false
          $('.messages').append('<div class="n">Number does not qualify.</div>')
          Meteor.setTimeout((-> $('.n').remove()), delay)
          delay += delay_increment
        if (C % 3 == 0)
          v_color = true
        else
          v_color = false
          $('.messages').append('<div class="c">Color does not qualify.</div>')
          Meteor.setTimeout((-> $('.c').remove()), delay)
          delay += delay_increment
        if (SD % 3 == 0)
          v_shade = true
        else
          v_shade = false
          $('.messages').append('<div class="sd">Shade does not qualify.</div>')
          Meteor.setTimeout((-> $('.sd').remove()), delay)
          delay += delay_increment
        if (SP % 3 == 0)
          v_shape = true
        else
          v_shape = false
          $('.messages').append('<div class="sp">Shape does not qualify.</div>')
          Meteor.setTimeout((-> $('.sp').remove()), delay)
          delay += delay_increment
        if (v_number && v_color && v_shade && v_shape)
          $('.messages').append('<div class="v">Valid Set!</div>')
          Meteor.setTimeout((-> $('.v').remove()), delay + 200)
          setargs = []
          setargs.push card._id for card in introset
          console.log(setargs)
          Meteor.setTimeout((-> $('.intro-selected').removeClass('intro-selected')))
          set = []
        else
          set = []
          Meteor.setTimeout((-> $('.intro-selected').removeClass('intro-selected')), 250)
    else if Session.get("selection-type") == "superunknown"
      if ($('.intro-card.intro-selected').length == 6)
        setargs = []
        setargs.push card._id for card in set
        console.log(setargs)
        Meteor.setTimeout((-> $('.intro-selected').removeClass('intro-selected')))
        set = []
