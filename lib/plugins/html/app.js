(function() {
  var app = angular.module('resultView', []);
  app.controller('ResultController', function($scope) {
    $scope.data = {
      results: [{}]
    }
    $scope.setRows = function (rows) {
      $scope.data.results = rows.length ? rows : [{}]
    }
  });
}())
