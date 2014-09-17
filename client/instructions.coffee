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

introset = []

Template.instructions.events
  'click .intro-card': (e, template) ->
    e.preventDefault();
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
    if Session.get("selection-type") == "normal"
      if ($('.intro-card.intro-selected').length == 3)
        delay = 3500
        delay_increment = 750
        set1 = ['card01','card02','card03']
        set2 = ['card01','card06','card09']
        set3 = ['card02','card06','card08']
        set4 = ['card03','card06','card10']
        set5 = ['card08','card09','card10']
        introset.sort();
        if introset.equals(set1)
          $('.intromessages').append('<div class="v">You found the set mentioned in the instructions!</div>')
          Meteor.setTimeout((-> $('.v').remove()), delay + 200)
        else if introset.equals(set2)
          $('.intromessages').append('<div class="v">You found a set where all qualities are different!</div>')
          Meteor.setTimeout((-> $('.v').remove()), delay + 200)
        else if introset.equals(set3)
          $('.intromessages').append('<div class="v">You found a set where all qualities are different!</div>')
          Meteor.setTimeout((-> $('.v').remove()), delay + 200)
        else if introset.equals(set4)
          $('.intromessages').append('<div class="v">You found an all red set!</div>')
          Meteor.setTimeout((-> $('.v').remove()), delay + 200)
        else if introset.equals(set5)
          $('.intromessages').append('<div class="v">You found an set where only color differs!</div>')
          Meteor.setTimeout((-> $('.v').remove()), delay + 200)
        else
          $('.intromessages').append('<div class="v">Not a set!</div>')
          Meteor.setTimeout((-> $('.v').remove()), delay + 200)
        introset = []
        Meteor.setTimeout((-> $('.intro-selected').removeClass('intro-selected')), 250)
