$(document).ready ()->
    $('.cover-page .couple .c-left')
        .click () ->
            window.location = 'http://chi.zhangs.me/zc'
        .mouseenter () ->
            tgt = $('.cover-page .couple .c-right:first')
            tgt.addClass 'c-unhover'
            tgt.removeClass 'c-normal'
        .mouseleave () ->
            tgt = $('.cover-page .couple .c-right:first')
            tgt.addClass 'c-normal'
            tgt.removeClass 'c-unhover'
    $('.cover-page .couple .c-right')
        .click () ->
            window.location = 'http://xuan.zhangs.me/zx'
        .mouseenter () ->
            tgt = $('.cover-page .couple .c-left:first')
            tgt.addClass 'c-unhover'
            tgt.removeClass 'c-normal'
        .mouseleave () ->
            tgt = $('.cover-page .couple .c-left:first')
            tgt.addClass 'c-normal'
            tgt.removeClass 'c-unhover'
