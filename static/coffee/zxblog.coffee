
sys_cfg =
    about_url: '/static/about.html'
    portfolio_url: '/static/portfolio.html'

angular.module('zxblog', ['ngRoute'])

.config ($routeProvider) ->
    $routeProvider
        .when('/about', {
            controller: 'AboutCtrl'
            templateUrl: sys_cfg.about_url
            })
        .when('/portfolio', {
            controller: 'PortfolioCtrl'
            templateUrl: sys_cfg.portfolio_url
            })
        .otherwise {redirectTo: '/about'}

.controller 'PortfolioCtrl', ($rootScope, $scope) ->
    $rootScope.$pg_type = 'portfolio'        

.controller 'AboutCtrl', ($rootScope, $scope) ->
    $rootScope.$header_logo_cls = 'header-bar-logo-about'
    b = 2

.controller 'MainCntl', ($rootScope, $scope) ->
    $scope.$header_logo_cls = 'header-bar-logo-normal'
    #$scope.$pg_type = 'portfolio'
    b = 1
