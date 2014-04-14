$(document).ready ()->
    $('.cover-page .couple .c-left')
        .click () ->
            window.location = 'http://chi.zhangs.me/zc'
        .mouseenter (event) ->
            $(event.target).css 'margin-top', '-1px'
        .mouseleave (event) ->
            $(event.target).css 'margin-top', '0px'
    $('.cover-page .couple .c-right')
        .click () ->
            window.location = 'http://xuan.zhangs.me/zx'
        .mouseenter (event) ->
            $(event.target).css 'margin-top', '-1px'
        .mouseleave (event) ->
            $(event.target).css 'margin-top', '0px'
