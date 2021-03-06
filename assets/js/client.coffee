#= require jquery
#= require bootstrap
#= require socket.io
#= require underscore

$( ->
  # set up the socket.io
  socket = io.connect() 

  directions = 
    left: false
    up: false
    stop: false
    right: false
    down: false

  emitStuff = ->
    chan = ''
    msg = ''

    if directions.up
      chan = 'up'

    if directions.up && directions.left
      chan = 'forwardLeft'

    if directions.up && directions.right
      chan = 'forwardRight'

    if directions.down
      chan = 'down'

    if directions.left
      chan = 'left'
      
    if directions.right
      chan = 'right'

    if !chan then chan = 'stop'

    if chan == 'stop' then msg = 'stop'

    socket.emit chan, msg

  socket.on "connection", (msg) ->
    socket.emit "hello", "world"

  socket.on "feedback", (msg) ->
    $("#feedback").text msg

  $('.emitter').on 'mousedown, touchstart', (e)->
    $el = $(e.currentTarget)
    directions[$el.data('channel')] = true
    emitStuff()
    #socket.emit $el.data('channel'), $el.data 'value'

  $('.emitter').on 'mouseup, touchend', (e)->
    $el = $(e.currentTarget)
    directions[$el.data('channel')] = false
    #emitStuff()

  $(window).keydown (e)->
    for el in $("[data-keyboard]")
      $el = $(el)
      if e.which == $el.data 'keyboard'
        directions[$el.data('channel')] = true
        emitStuff()
        #socket.emit $el.data('channel'), $el.data 'value'

  $(window).keyup (e)->
    for el in $("[data-keyboard]")
      $el = $(el)
      if e.which == $el.data 'keyboard'
        directions[$el.data('channel')] = false
        emitStuff()   
    #socket.emit "stop", "stop"

)
