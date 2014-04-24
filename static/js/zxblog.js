// Generated by CoffeeScript 1.4.0
var page_generator, sys_cfg;

sys_cfg = {
  about_url: '/static/about.html',
  portfolio_url: '/static/portfolio.html',
  blogs_url: '/static/blogs.html',
  post_url: '/static/post.html',
  portfolio_data_url: '/wp_api/v1/posts?category_name=portfolio&per_page=12',
  posts_data_url: '/wp_api/v1/posts?per_page=10',
  post_data_url: '/wp_api/v1/posts/:postid',
  comments_data_url: '/wp_api/v1/posts/:postid/comments?paged=1&per_page=5',
  cats_list_url: '/wp_api/v1/taxonomies/category/terms?parent=4&orderby=slug',
  ani_dur: 300
};

angular.module('zxblog', ['ngRoute', 'ngResource', 'ngSanitize', 'ngAnimate']).config(function($routeProvider) {
  return $routeProvider.when('/', {
    controller: 'AboutCtrl',
    templateUrl: sys_cfg.about_url
  }).when('/portfolio/:page', {
    controller: 'PortfolioCtrl',
    templateUrl: sys_cfg.portfolio_url
  }).when('/posts/:catname/:page', {
    controller: 'BlogsCtrl',
    templateUrl: sys_cfg.blogs_url
  }).when('/post/:postid', {
    controller: 'PostCtrl',
    templateUrl: sys_cfg.post_url
  }).otherwise({
    redirectTo: '/'
  });
}).controller('BlogsCtrl', function($rootScope, $scope, $routeParams, postsFactory) {
  var cat_name, fat_param, posts_info;
  $rootScope.$pg_type = 'post';
  $rootScope.$header_logo_cls = 'header-bar-logo-normal';
  cat_name = $routeParams.catname === 'all' ? '1-blog' : $routeParams.catname;
  fat_param = {
    category_name: cat_name,
    paged: $routeParams.page
  };
  $scope.loading = true;
  return posts_info = postsFactory.get(fat_param, function() {
    $scope.loading = false;
    $scope.$posts = posts_info.posts;
    $scope.$current_page = $routeParams.page;
    $scope.$catname = $routeParams.catname;
    return $scope.$pgs = page_generator(posts_info.found, 5, $routeParams.page);
  });
}).factory('postsFactory', [
  '$resource', function($resource) {
    return $resource(sys_cfg.posts_data_url, null, {});
  }
]).controller('PostCtrl', function($rootScope, $scope, $routeParams, postFactory, commentsFactory) {
  var comments, post_info;
  $rootScope.$pg_type = 'post';
  $rootScope.$header_logo_cls = 'header-bar-logo-normal';
  $scope.loading = true;
  $(window).scrollTop(0);
  $scope.save = function() {
    var coll, com_param, eat, k, q, _i, _len, _ref;
    $scope.$comment.date = 'Just now';
    $scope.$comments.unshift($scope.$comment);
    q = ["comment_post_ID=" + $routeParams.postid];
    coll = function(p) {
      return q.push(p + "=" + $scope.$comment[p]);
    };
    _ref = ['comment', 'author', 'email'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      k = _ref[_i];
      coll(k);
    }
    com_param = {
      method: 'POST',
      url: '/wp_api/v1/posts/' + $routeParams.postid + '/comments',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      data: q.join('&')
    };
    eat = function(k) {
      return $scope.$comment[k] = '';
    };
    return postFactory.poster(com_param).then(function(response) {
      return $scope.$comment = {};
    });
  };
  post_info = postFactory.getter.get({
    postid: $routeParams.postid
  }, function() {
    $scope.$post = post_info;
    return $scope.loading = false;
  });
  return comments = commentsFactory.get({
    postid: $routeParams.postid
  }, function() {
    return $scope.$comments = comments.comments;
  });
}).directive('fancyIt', [
  '$compile', function($compile) {
    return function(scope, element, attrs) {
      return scope.$watch('$post', function(n_val, o_val) {
        if (n_val && (!o_val)) {
          element.html(n_val.content_display);
          $(window).scrollTop(0);
          return $('.post-page .post-content a>img').each(function() {
            return $(this).parent().fancybox();
          });
        }
      });
    };
  }
]).directive('loading', function() {
  return {
    restrict: 'E',
    replace: true,
    template: '<div class="loading"><img src="/static/imgs/loading.gif"></div>',
    link: function(scope, element, attr) {
      return scope.$watch('loading', function(val) {
        if (val) {
          return $(element).show();
        } else {
          return $(element).hide();
        }
      });
    }
  };
}).factory('postFactory', [
  '$resource', '$http', function($resource, $http) {
    return {
      getter: $resource(sys_cfg.post_data_url, {
        id: '@postid'
      }, {}),
      poster: function(com_param) {
        $http.defaults.headers.post["Content-Type"] = "application/json";
        return $http(com_param);
      }
    };
  }
]).factory('commentsFactory', [
  '$resource', function($resource) {
    return $resource(sys_cfg.comments_data_url, {
      id: '@postid'
    }, {});
  }
]).controller('CatsCtrl', function($rootScope, $scope, $routeParams, catsFactory) {
  var cats_info;
  return cats_info = catsFactory.get({}, function() {
    var cat, cats, pghd, _i, _len, _ref, _ref1;
    cats = [
      {
        name: 'all',
        slug: '1-blog'
      }
    ];
    pghd = function(cat) {
      return cats.push(cat);
    };
    _ref = cats_info.terms;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cat = _ref[_i];
      if (!((_ref1 = cat.name) === '未分类' || _ref1 === 'portfolio' || _ref1 === 'blog')) {
        pghd(cat);
      }
    }
    $scope.$cats = cats;
    return $scope.$cat_name = $routeParams.catname === 'all' ? '1-blog' : $routeParams.catname;
  });
}).factory('catsFactory', [
  '$resource', function($resource) {
    return $resource(sys_cfg.cats_list_url, null, {});
  }
]).controller('PortfolioCtrl', function($rootScope, $scope, $routeParams, portFactory) {
  var ports_info;
  $rootScope.$pg_type = 'portfolio';
  $rootScope.$header_logo_cls = 'header-bar-logo-normal';
  $scope.loading = true;
  return ports_info = portFactory.get({
    paged: $routeParams.page
  }, function() {
    $scope.loading = false;
    console.log(ports_info);
    $scope.$ports = ports_info.posts;
    $scope.$port_count = ports_info.found;
    $scope.$current_page = $routeParams.page;
    return $scope.$pgs = page_generator(ports_info.found, 12, $routeParams.page);
  });
}).factory('portFactory', [
  '$resource', function($resource) {
    return $resource(sys_cfg.portfolio_data_url, null, {});
  }
]).controller('AboutCtrl', function($rootScope, $scope) {
  $rootScope.$pg_type = 'about';
  $rootScope.$header_logo_cls = 'header-bar-logo-about';
  return $(window).scrollTop(0);
}).controller('MainCntl', function($rootScope, $scope) {
  var b;
  return b = 1;
});

page_generator = function(total, per, current) {
  var hd, lks, pg, pghd, pgs, tl, _i;
  pgs = Math.floor((total + per - 1) / per);
  if (pgs < 11) {
    hd = 1;
    tl = pgs;
  } else if (current < 6) {
    hd = 1;
    tl = 10;
  } else if ((current + 5) > pgs) {
    tl = pgs;
    hd = pgs - 9;
  } else {
    hd = current - 4;
    tl = current + 5;
  }
  lks = [];
  if (hd > 1) {
    lks.push({
      pg: 1,
      txt: '<<'
    });
  }
  pghd = function(pg) {
    return lks.push({
      pg: pg,
      txt: pg
    });
  };
  for (pg = _i = hd; hd <= tl ? _i <= tl : _i >= tl; pg = hd <= tl ? ++_i : --_i) {
    pghd(pg);
  }
  if (pgs > tl) {
    lks.push({
      pg: pgs,
      txt: '>>'
    });
  }
  return lks;
};

$(document).ready(function() {
  var blank_div, fix_div, position;
  fix_div = $('#header-bar-box');
  blank_div = $('#blank_div');
  position = fix_div.position();
  return $(window).scroll(function(event) {
    var ani_op, ani_pam, winpos, _ref;
    winpos = $(window).scrollTop();
    if (winpos >= 170) {
      $('.coffee-link').hide();
    } else {
      $('.coffee-link').show();
    }
    if ((_ref = sys_cfg.shrink_header) == null) {
      sys_cfg.shrink_header = false;
    }
    if (winpos >= 240) {
      if (!sys_cfg.strink_header) {
        if (fix_div.height() < 61) {
          return '';
        }
        sys_cfg.strink_header = true;
        fix_div.css('top', 0);
        ani_pam = {
          height: 60
        };
        ani_op = {
          duration: sys_cfg.ani_dur,
          progress: function() {
            return $('#blank_div').height(240 + $('.header-bar-box').height() + 'px');
          },
          complete: function() {
            return sys_cfg.strink_header = false;
          }
        };
        return fix_div.animate(ani_pam, ani_op);
      }
    } else {
      if (winpos < 1) {
        winpos = 0;
      }
      if (1) {
        ani_pam = {
          height: 120
        };
        ani_op = {
          duration: 30,
          progress: function() {
            var btop, fh;
            fh = fix_div.height();
            btop = 240 + fh + 'px';
            blank_div.height(btop);
            return fix_div.css('top', 240 - winpos + 'px');
          },
          complete: function() {
            return sys_cfg.strink_header = false;
          }
        };
        if (fix_div.height() > 119) {
          return fix_div.css('top', 240 - winpos + 'px');
        } else {
          sys_cfg.strink_header = true;
          fix_div.stop();
          return fix_div.animate(ani_pam, ani_op);
        }
      }
    }
  });
});
