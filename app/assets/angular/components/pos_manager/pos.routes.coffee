angular.module("posManager").config(['$stateProvider', ($stateProvider) ->
  pos =
    name: 'root.pos'
    displayName: 'POS Manager'
    parent: 'root'
    url: '/'
    templateUrl: 'components/pos_manager/pos.layout.html'
    controller: 'posCtrl as sb'

  $stateProvider.state(pos)
])
