angular.module("posManager").config(['$stateProvider', ($stateProvider) ->
  root =
    name: 'root'
    displayName: 'root'
    abstract: true
    controller: 'mainCtrl as main'
    views:
      '':
        templateUrl: 'components/core/core.layout.html'
      'toolbar@root':
        templateUrl: 'components/core/core.toolbar.html'
      'footer@root':
        templateUrl: 'components/core/core.footer.html'

  $stateProvider.state(root)
])
