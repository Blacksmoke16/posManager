angular.module("posManager").controller 'posCtrl', ['$scope', 'posService', ($scope, posService) -> do =>
    @data = []
    @time = 24
    @exportData = []
    @regionFuels = []
    @isDisabled = false
    @range = true

    regionFuel = (name) =>
      list = _.flatten(_.map(@data, (r) -> _.filter(_.filter(r, visible: true), (t) -> t.regionName is name)))
      @regionFuels = _.fromPairs(_.sortBy(_.map(_.map(_.uniqBy(_.filter(list,
        visible: true), 'fuelTypeName'), 'fuelTypeName'), (@r) -> [r,
        _.sumBy(_.filter(_.filter(list, (p) -> p.visible), fuelTypeName: r), 'fuelConsumption')])), @r)

    update = (pos, truthy) =>
      if truthy == undefined
        truthy = true
      else
        pos.visible = truthy
      pos.posID = pos.itemID
      if validateInput(pos.note)
        pos.note = pos.note.toString()
        if pos.hasRecord
          posService.updatePOS(pos).then (response) =>
            if pos.note[0] == ""
              pos.note = []
            else
              pos = _.find(@rawData, itemID: response.data.posID)
              pos.note = response.data.note.split(',')
            getTags()
        else
          posService.addPOS(pos).then (response) =>
            if pos.note[0] == ""
              pos.note = []
            else
              pos = _.find(@rawData, itemID: response.data.posID)
              pos.note = response.data.note.split(',')
            getTags()
            pos.hasRecord = true
      else pos.note = _.without(pos.note, _.last(pos.note))

    regionVisible = (region) =>
      _.some(@data[region], visible: true)

    posInvisible = =>
      _.flatten(_.map(@data, (r) -> _.filter(r, visible: false)))

    fuelInvisible = =>
      list = _.flatten(_.map(@data, (r) -> _.filter(r, visible: true)))
      _.fromPairs(_.sortBy(_.map(_.map(_.uniqBy(_.filter(list,
        visible: true), 'fuelTypeName'), 'fuelTypeName'), (@r) -> [r,
        _.sumBy(_.filter(_.filter(list, (p) -> p.visible), fuelTypeName: r), 'fuelConsumption')])), @r)

    getSiloClass = (v) =>
      if v == 427
        'raw'
      else if v == 428
        'intermediate'
      else
        'composite'

    getPosClass = (v) =>
      if v >= 168
        'high'
      else if v > 72
        'medium'
      else
        'low'

    getStateClass = (s) =>
      state = s.state
      if s.siphon
        'siphon blink'
      else if state == 'Online'
        'online'
      else if state == 'Reinforced'
        'reinforced'
      else if state == 'Anchored'
        'anchored'
      else if state == 'Onlining'
        'onlining'
      else if state == 'Unanchored'
        'unanchored'

    validateInput = (value) =>
      if isFinite(parseInt(_.last(value)))
        false
      else
        true

    getTags = () =>
      @tags = []
      for row in @rawData
        for n in row.note
          @tags.push (n) if row.note.length > 0
        @tags = _.uniq(@tags)

    init = =>
      posService.getPOSs().then (response) =>
        @rawData = response.data
        @data = _.fromPairs(_.sortBy(_.map(_.map(_.uniqBy(response.data, 'regionName'), 'regionName'), (@r) -> [r,
          _.filter(response.data, regionName: r)]), @r))
        regionFuel(_.first(_.keys(@data)))
        getTags()

    init()

    #-- Public Functions

    @update = update
    @regionVisible = regionVisible
    @posInvisible = posInvisible
    @fuelInvisible = fuelInvisible
    @getSiloClass = getSiloClass
    @getPosClass = getPosClass
    @getStateClass = getStateClass
    @regionFuel = regionFuel

    return
]