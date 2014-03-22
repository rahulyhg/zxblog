
sys_cfg =
    about_url: '/static/about.html'
    portfolio_url: '/static/portfolio.html'
    blogs_url: '/static/blogs.html'
    post_url: '/static/post.html'
    portfolio_data_url: '/wp_api/v1/posts?category_name=portfolio&per_page=12'
    posts_data_url: '/wp_api/v1/posts?per_page=10'
    post_data_url: '/wp_api/v1/posts/:postid'
    comments_data_url: '/wp_api/v1/posts/:postid/comments?paged=1&per_page=5'
    cats_list_url: '/wp_api/v1/taxonomies/category/terms?parent=4&orderby=slug'
    ani_dur: 300

angular.module('zxblog', ['ngRoute', 'ngResource', 'ngSanitize'])

.config ($routeProvider) ->
    $routeProvider
        .when '/about',
            controller: 'AboutCtrl'
            templateUrl: sys_cfg.about_url
        .when '/portfolio/:page',
            controller: 'PortfolioCtrl'
            templateUrl: sys_cfg.portfolio_url
        .when '/posts/:catname/:page',
            controller: 'BlogsCtrl'
            templateUrl: sys_cfg.blogs_url
        .when '/post/:postid',
            controller: 'PostCtrl'
            templateUrl: sys_cfg.post_url
        .otherwise
            redirectTo: '/about'
.controller 'BlogsCtrl', ($rootScope, $scope, $routeParams, postsFactory)->
    # ui related
    $rootScope.$pg_type = 'post'
    $rootScope.$header_logo_cls = 'header-bar-logo-normal'
    cat_name = if ($routeParams.catname == 'all') then '1-blog' else $routeParams.catname
    fat_param = {
        category_name: cat_name
        paged: $routeParams.page
        }
    posts_info = postsFactory.get fat_param, () ->
        $scope.$posts = posts_info.posts
        $scope.$current_page = $routeParams.page
        $scope.$catname = $routeParams.catname
        $scope.$pgs = page_generator posts_info.found, 5, $routeParams.page
        
.factory('postsFactory', ['$resource', ($resource) ->
    $resource sys_cfg.posts_data_url, null, {}])
.controller('PostCtrl', ($rootScope, $scope, $routeParams, postFactory, commentsFactory)->
    $rootScope.$pg_type = 'post'
    $rootScope.$header_logo_cls = 'header-bar-logo-normal'
    $(window).scrollTop 0

    #post comment related
    $scope.save = () ->
        # we can add the comment loaclly
        $scope.$comment.date = 'Just now'
        $scope.$comments.unshift $scope.$comment
        q = ["comment_post_ID=" + $routeParams.postid]
        coll = (p) ->
            q.push p + "=" + $scope.$comment[p]
        coll k for k in ['comment', 'author', 'email']
        
        com_param =
            method: 'POST'
            url: '/wp_api/v1/posts/' + $routeParams.postid + '/comments'
            headers: {'Content-Type': 'application/x-www-form-urlencoded'}
            data: q.join '&'

        eat = (k) ->
            $scope.$comment[k] = '' 
        postFactory.poster(com_param).then (response)->
            $scope.$comment = {}
            
    post_info = postFactory.getter.get {postid: $routeParams.postid}, () ->
        $scope.$post = post_info
    comments = commentsFactory.get  {postid: $routeParams.postid}, () ->
        $scope.$comments = comments.comments
        )
.directive('fancyIt', ['$compile', ($compile)->
    (scope, element, attrs) ->
        scope.$watch '$post', (n_val, o_val) ->
            if n_val and (not o_val)
                element.html n_val.content_display
                $(window).scrollTop 0
                $('.post-page .post-content a>img').each ()->
                    $(this).parent().fancybox()
    ])
.factory('postFactory', ['$resource', '$http', ($resource, $http) ->
    return {
        getter: $resource sys_cfg.post_data_url, {id: '@postid'}, {}
        poster: (com_param) ->
            $http.defaults.headers.post["Content-Type"] = "application/json"
            $http(com_param)
                
    }])
.factory('commentsFactory', ['$resource', ($resource) ->
    $resource sys_cfg.comments_data_url, {id: '@postid'}, {}])

.controller 'CatsCtrl', ($rootScope, $scope, $routeParams, catsFactory)->
    cats_info = catsFactory.get {}, () ->
        cats = [{name: 'all', slug: '1-blog'}]
        pghd = (cat)->
            cats.push cat
        pghd cat for cat in cats_info.terms when (not (cat.name in ['未分类', 'portfolio', 'blog']))
        $scope.$cats = cats
        $scope.$cat_name = if ($routeParams.catname == 'all') then '1-blog' else $routeParams.catname

.factory('catsFactory', ['$resource', ($resource) ->
    $resource sys_cfg.cats_list_url, null, {}])

.controller 'PortfolioCtrl', ($rootScope, $scope, $routeParams, portFactory) ->
    # ui related
    $rootScope.$pg_type = 'portfolio'
    $rootScope.$header_logo_cls = 'header-bar-logo-normal'

    ports_info = portFactory.get {paged: $routeParams.page}, () ->
        console.log ports_info
        $scope.$ports = ports_info.posts
        $scope.$port_count = ports_info.found
        $scope.$current_page = $routeParams.page
        $scope.$pgs = page_generator ports_info.found, 12, $routeParams.page

.factory('portFactory', ['$resource', ($resource) ->
    $resource sys_cfg.portfolio_data_url, null, {}])

.controller 'AboutCtrl', ($rootScope, $scope) ->
    $rootScope.$pg_type = 'about'
    $rootScope.$header_logo_cls = 'header-bar-logo-about'
    $(window).scrollTop 0

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

$(document).ready ()->
    fix_div = $ '#header-bar-box'
    blank_div = $ '#blank_div'
    position = fix_div.position()
    $(window).scroll (event)->
        winpos = $(window).scrollTop()
        if winpos >= 170
            $('.coffee-link').hide()
        else
            $('.coffee-link').show()
        sys_cfg.shrink_header ?= false
        if winpos >= 240 #position.top
            if not sys_cfg.strink_header
                if fix_div.height() < 61
                    return ''
                sys_cfg.strink_header = true
                fix_div.css 'top', 0
                ani_pam =
                    height: 60
                ani_op =
                    duration: sys_cfg.ani_dur
                    progress: () ->
                        $('#blank_div').height 240+$('.header-bar-box').height()+'px'
                    complete: () ->
                        sys_cfg.strink_header = false
                fix_div.animate ani_pam, ani_op
        else
            if winpos < 1
                winpos = 0
            if 1
                ani_pam =
                    height: 120
                ani_op =
                    duration: 30
                    progress: () ->
                        fh = fix_div.height()
                        btop = 240+fh+'px'
                        blank_div.height btop
                        fix_div.css 'top', 240-winpos+'px'
                    complete: () ->
                        sys_cfg.strink_header = false
                if fix_div.height() > 119
                    fix_div.css 'top', 240-winpos+'px'
                else
                    sys_cfg.strink_header = true
                    fix_div.stop()
                    fix_div.animate ani_pam, ani_op
