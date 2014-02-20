
sys_cfg =
    about_url: '/static/about.html'
    portfolio_url: '/static/portfolio.html'
    portfolio_data_url: '/wp_api/v1/posts?category_name=portfolio&per_page=15'

angular.module('zxblog', ['ngRoute', 'ngResource'])

.config ($routeProvider) ->
    $routeProvider
        .when('/about', {
            controller: 'AboutCtrl'
            templateUrl: sys_cfg.about_url
            })
        .when('/portfolio/:page', {
            controller: 'PortfolioCtrl'
            templateUrl: sys_cfg.portfolio_url
            })
        .otherwise {redirectTo: '/about'}

.controller 'PortfolioCtrl', ($rootScope, $scope, $routeParams, portFactory) ->
    # ui related
    $rootScope.$pg_type = 'portfolio'
    $rootScope.$header_logo_cls = 'header-bar-logo-normal'

    ports_info = portFactory.get {paged: $routeParams.page}, () ->
        $scope.$ports = ports_info.posts
        $scope.$port_count = ports_info.found
        $scope.$current_page = $routeParams.page

.factory('portFactory', ['$resource', ($resource) ->
    $resource sys_cfg.portfolio_data_url, null, {}])

.controller 'AboutCtrl', ($rootScope, $scope) ->
    $rootScope.$header_logo_cls = 'header-bar-logo-about'
    b = 2

.controller 'MainCntl', ($rootScope, $scope) ->
    #$scope.$pg_type = 'portfolio'
    b = 1
