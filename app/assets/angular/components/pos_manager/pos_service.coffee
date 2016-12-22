app.factory 'posService', ['$http', ($http) ->
  factory = {}
  # POSs
  factory.getPOSs = ->
    return $http.get("api/v1/sbs")

  factory.updatePOS = (pos) ->
    return $http.patch("/api/v1/usbs/#{pos.itemID}", PosTrackerUser: pos, headers: {'Content-type': 'application/json'})

  factory.addPOS = (pos) ->
    return $http.post("/api/v1/usbs", PosTrackerUser: pos, headers: {'Content-type': 'application/json'})

  return factory
]