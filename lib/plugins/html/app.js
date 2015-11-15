(function() {
  var app = angular.module('resultView', []);
  var data = [
    {
      platform: "Sms",
      content: "I respect women.",
      author: "Spoderman",
      date: "9/10/11"
    },
    {
      platform: "GroupMe",
      content: "I totally would put it in her butt.",
      author: "Chase Davis",
      date: "10/11/12"
    }
  ];
  app.controller('ResultController', function($scope) {
    $scope.results = data
  });
}())
