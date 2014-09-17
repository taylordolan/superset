Meteor.subscribe('cards');
Meteor.subscribe('gamecards');
Meteor.subscribe('games');
Meteor.subscribe('statistics');

Session.setDefault("counter", 0)
Session.setDefault("interface-type", "card")
Session.setDefault("selection-type", "normal")
Session.setDefault("isometric", "false")
Session.setDefault("selection-limit", 3)
Session.setDefault("dark","false")

@shapes = ['diamond', 'oval', 'squiggle']
@colors = ['green', 'purple', 'red']
@shades = ['empty', 'shaded', 'solid']
@numbers = ['one', 'two', 'three']

@keybindings = ['81','87','69','82']
@keybindings = ['65','83','68','70']
@keybindings = ['90','88','67','86']

@key = []
@key[81] = 0
@key[87] = 1
@key[69] = 2
@key[82] = 3
@key[65] = 4
@key[83] = 5
@key[68] = 6
@key[70] = 7
@key[90] = 8
@key[88] = 9
@key[67] = 10
@key[86] = 11

@game = 0

set = []

Template.globalGame.events
  'click .check': () ->
    Meteor.call 'check_sets', game, (error, result) ->
      if error
        console.log(error)
      else
        $('.messages').append('<div class="chk">'+result+'</div>')
        Meteor.setTimeout((-> $('.chk').remove()), 1000)
  'click .display': ->
    if Session.get("interface-type") == "card"
      $('.button.display').addClass('pressed')
      Session.set("interface-type","textcard")
    else
      $('.button.display').removeClass('pressed')
      Session.set("interface-type","card")
  'click .mode': ->
    if Session.get("selection-type") == "normal"
      $('.button.mode').addClass('pressed')
      Session.set("selection-type","superunknown")
      Session.set("selection-limit", 6)
    else
      $('.button.mode').removeClass('pressed')
      Session.set("selection-type","normal")
      Session.set("selection-limit", 3)
      $('.button.isometric').removeClass('pressed')
      Session.set("isometric","false")
  'click .isometric': ->
    if Session.get("isometric") == "false"
      $('.button.isometric').addClass('pressed')
      $('.button.mode').addClass('pressed')
      Session.set("isometric","true")
      Session.set("selection-type","superunknown")
      Session.set("selection-limit", 6)
    else
      $('.button.isometric').removeClass('pressed')
      Session.set("isometric","false")
  'click .vision': ->
      if Session.get("dark") == "false"
        $('body').addClass('dark')
        $('.button').not('.vision').addClass('dark')
        $('.vision').removeClass('dark').addClass('light')
        Session.set("dark","true")
      else
        $('body').removeClass('dark')
        $('.button').removeClass('dark')
        $('.vision').removeClass('light').addClass('dark')
        Session.set("dark","false")

doSelect = (item) ->
  if typeof(item.id) != 'undefined'
    item = $('#' + item.id)
  if ($(item).hasClass('selected'))
    $(item).removeClass('selected')
    i = 0
    match = 0
    for card in set
      console.log('2 ids')
      console.log(card.id)
      console.log(item.id)
      if (card.id == item.id)
        match = i
      i++
    t = set.splice(match,1)
  else
    if ($('.card.selected').length < Session.get("selection-limit"))
      $(item).addClass('selected')
      set.push(item)

  console.log('selected cards ' + $('.card.selected').length)
  for card in set
    console.log('attr')
    console.log(card)

  for card in set
    console.log('id')
    console.log(card.prop("id"))
  if Session.get("selection-type") == "normal"
    if ($('.card.selected').length == 3)
      N = 0
      C = 0
      SD = 0
      SP = 0
      (N = N + card.data("number"); C = C + card.data("color"); SD = SD + card.data("shade"); SP = SP + card.data("shape")) for card in set
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
        setargs.push card.prop("id") for card in set
        console.log(setargs)
        Meteor.call('set', game, setargs)
        Meteor.setTimeout((-> $('.selected').removeClass('selected')))
        set = []
      else
        set = []
        Meteor.setTimeout((-> $('.selected').removeClass('selected')), 250)
  else if Session.get("selection-type") == "superunknown"
    if ($('.card.selected').length == 6)
      setargs = []
      setargs.push card.prop("id") for card in set
      console.log(setargs)
      if Session.get("isometric") == "true"
        iso = 1
      Meteor.call 'SUset', game, setargs, iso, (error, result) ->
        if error
          console.log(error)
        else
          $('.messages').append('<div class="chk">'+result+'</div>')
          Meteor.setTimeout((-> $('.chk').remove()), 1750)
      Meteor.setTimeout((-> $('.selected').removeClass('selected')))
      set = []


Template.globalGame.events
  'click .card': (e, template) ->
    e.preventDefault();
    doSelect(e.target)

window.onkeyup = (e) ->
  if typeof(key[e.which]) != 'undefined'
    console.log($('.card').eq(key[e.which]).prop("id"))
    doSelect($('.card').eq(key[e.which]))

Template.nav.helpers
  statistics: () ->
    return Statistics.findOne()

Template.globalGame.helpers
  gamecards: () ->
    gc = Gamecards.find status: 'playing'
    cardIds = gc.map (c) -> return c.card_mid
    #console.log(cardIds)
    all = Cards.find({_id: {$in: cardIds}}).fetch()
    chunks = []
    size = 4
    #console.log("all : " + all.length)
    while (all.length > size)
      chunks.push({ row: all.slice(0, size)})
      all = all.slice(size)
    chunks.push({row: all});
    #console.log("all : " + all.length)
    return chunks
  buttonstate: (name,value) ->
    if Session.get(name) == value
      return 'pressed'

Template.cardrow.helpers
  cardDisplayType: ->
    return Session.get("interface-type")

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

Template.card.helpers
  numbers: (index) ->
    return numbers[index]
  colors: (index) ->
    return colors[index]
  shades: (index) ->
    return shades[index]
  shapes: (index, number) ->
    plural = if number > 0 then 's' else ''
    return shapes[index] + plural
  shapearray: (number) ->
    a = []
    for i in [0..number]
      a.push(i+1)
    return a
  shader: (shade,color) ->
    if shade == 1
      return "fill: url(#" + colors[color] + "-stripes);"
    else if shade == 2
      return "fill: " + colors[color] + ";"
    else if shade == 0
      return "fill: none;"
