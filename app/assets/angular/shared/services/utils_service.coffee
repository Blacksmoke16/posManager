app.factory 'utilsService', ['$mdToast',  ($mdToast) ->
  factory = {}

  factory.paginate = (data, page, limit) ->
# console.log 'commands: page', page, 'limit', limit
    result = []
    initial = (page - 1) * limit

    while initial > data.length
      page -= 1
      initial = (page - 1) * limit

    if data.length - initial >= limit
# and there are enough commands left to show at least the limit
      result = data.slice(initial, initial + limit)
    else
# or there aren't enough, and just show what's left
      result = data.slice(initial, data.length)

    return [result, page]

  factory.reorder = (data, order) ->
    reverse = false
    if order.indexOf('-') >= 0
      order = _.replace(order, '-', '')
      reverse = true
    data.sort (a, b) ->
      a[order] = parseInt(a[order]) unless isNaN(a[order])
      b[order] = parseInt(b[order]) unless isNaN(b[order])
      if a[order] < b[order] then return -1
      if a[order] > b[order] then return 1
      return 0
    data.reverse() if reverse
    return data

  factory.priceToIsk = (price,places = 0) ->
    if price >= 1000000000
      price /= 1000000000
      price = price.toFixed(places).toString() + 'B'
    else if price >= 1000000
      price /= 1000000
      price = price.toFixed(places).toString() + 'M'
    else if price >= 1000
      price /= 1000
      price = price.toFixed(places).toString() + 'K'
    else
      price = price.toFixed(places).toString()
    return price

  factory.toast = (response) ->
    message =
      switch response.status
        when 200 then 'Success!'
        when 201 then 'Created!'
        when 204 then 'Opened!'
        else 'Error?'

    $mdToast.show(
      $mdToast.simple()
        .textContent(message)
        .position('top right')
        .hideDelay(500))


  return factory
]