
sys_cfg =
    about_url: '/static/about.html'

angular.module('zxblog', ['ngRoute'])

.config ($routeProvider) ->
    $routeProvider
        .when('/about', {
            controller: 'AboutCtrl'
            templateUrl: sys_cfg.about_url
            })
        .otherwise {redirectTo: 'about'}

.controller 'AboutCtrl', ($scope, Projects) ->
    b = 1
    
