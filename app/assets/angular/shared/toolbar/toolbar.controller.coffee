angular.module("posManager").directive "toolbar", ->
  templateUrl: 'shared/toolbar/toolbar.layout.html'
  restrict: 'E'
  scope: {}
  controllerAs: 'ctrl'
  controller: ['$scope', '$mdSidenav', '$state', '$window', '$rootScope', '$mdDialog',
    ($scope, $mdSidenav, $state, $window, $rootScope, $mdDialog) -> do =>
      @page = ''

      getKeyFromValue = (obj, value)->
        for own k,v of obj
          if v == value
            return k

      init = =>
        @page = $state.current?.displayName ? ''

      init()

      $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams, options) =>
        @page = toState?.displayName ? ''

      #-- Public Functions

      return
  ]