
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
        console.log ports_info
        $scope.$ports = ports_info.posts
        $scope.$port_count = ports_info.found
        $scope.$current_page = $routeParams.page
        $scope.$pgs = page_generator ports_info.found*22, 15, $routeParams.page

.factory('portFactory', ['$resource', ($resource) ->
    $resource sys_cfg.portfolio_data_url, null, {}])

.controller 'AboutCtrl', ($rootScope, $scope) ->
    $rootScope.$pg_type = 'about'
    $rootScope.$header_logo_cls = 'header-bar-logo-about'
    b = 2

.controller 'MainCntl', ($rootScope, $scope) ->
    #$scope.$pg_type = 'portfolio'
    b = 1

page_generator = (total, per, current) ->
    pgs = Math.floor((total+per-1) / per)
    if pgs < 11
        hd = 1
        tl = pgs
    else if current < 6
        hd = 1
        tl = 10
    else if (current+5) > pgs
        tl = pgs
        hd = pgs - 9
    else
        hd = current - 4
        tl = current + 5
    lks = []
    lks.push {pg: 1, txt: '<<'} if hd > 1
    pghd = (pg)->
        lks.push {pg: pg, txt: pg}
    pghd pg for pg in [hd..tl]
    lks.push {pg: pgs, txt: '>>'} if pgs > tl
    return lks