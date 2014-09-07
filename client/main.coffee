Meteor.subscribe('cards');
Meteor.subscribe('gamecards');
Meteor.subscribe('games');
Meteor.subscribe('statistics');

Session.setDefault("counter", 0)

@shapes = ['diamond', 'oval', 'squiggle']
@colors = ['green', 'purple', 'red']
@shades = ['empty', 'shaded', 'solid']
@numbers = ['one', 'two', 'three']

set = []

Template.hello.helpers
  counter: () -> return Session.get("counter")

Template.globalGame.events
  'click button': () ->
    Meteor.call('check_sets',
      (error, result) ->
        if error
          console.log(error)
        else
          $('.messages').append('<div class="chk">'+result+'</div>')
          Meteor.setTimeout((-> $('.chk').remove()), 1000)
    )

Template.globalGame.events
  'click .card': (e, template) ->
    if ($(e.target).hasClass('selected'))
      $(e.target).removeClass('selected')
      i = 0
      (if (card._id == this._id) then console.log('match ' + i); match = i; i++;) for card in set
      set.splice(match,1)
      console.log(set)
    else
      if ($('.card.selected').length < 3)
        $(e.target).addClass('selected')
        set.push(this)

    console.log('selected cards ' + $('.card.selected').length)
    if ($('.card.selected').length == 3)
      N = 0
      C = 0
      SD = 0
      SP = 0
      (N = N + card.number; C = C + card.color; SD = SD + card.shade; SP = SP + card.shape) for card in set
      delay = 1500
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
        setargs.push card._id for card in set
        console.log(setargs)
        Meteor.call('set', setargs)
        Meteor.setTimeout((-> $('.selected').removeClass('selected')))
        set = []
      else
        set = []
        Meteor.setTimeout((-> $('.selected').removeClass('selected')), 250)


Template.globalGame.helpers
  gamecards: () ->
    gc = Gamecards.find({status: 'playing'})
    cardIds = gc.map( (c) -> return c.card_mid )
    console.log(cardIds)
    all = Cards.find({_id: {$in: cardIds}}).fetch();
    chunks = []
    size = 4
    console.log("all : " + all.length)
    while (all.length > size)
      chunks.push({ row: all.slice(0, size)})
      all = all.slice(size)
    chunks.push({row: all});
    console.log("all : " + all.length)
    return chunks


Template.textcard.helpers
  numbers: (index) ->
    return numbers[index]
  colors: (index) ->
    return colors[index]
  shades: (index) ->
    return shades[index]
  shapes: (index, number) ->
    plural = if number > 0 then 's' else ''
    return shapes[index] + plural


# Template.card.helpers
#   card: (card_id) ->
#     return Cards.findOne({_id: card_id})
