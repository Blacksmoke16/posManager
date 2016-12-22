app.filter 'timeRemaining', ->
  (item, countdown) ->
    days = Math.floor(item / 24)
    hours = Math.floor(item) % 24
    minutes = ((item - Math.floor(item)) * 60).toFixed(2)
    dayString = if days > 1 then ' days ' else ' day '
    hourString = if hours isnt 1 then ' hours ' else ' hour '
    minuteString = if minutes isnt 1 then ' minutes ' else ' minute '
    if !countdown
      if days == 0 and hours == 0 and minutes == 0
        return 'N/A'
      else if days > 0
        return days + dayString + hours + hourString + minutes + minuteString
      else if hours > 0
        return hours + hourString + minutes + minuteString
      else
        return minutes + minuteString
    else
      return days + dayString