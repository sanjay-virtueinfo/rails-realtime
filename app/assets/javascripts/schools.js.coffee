$ ->
  $('a.load-more-schools').on 'click', (e, visible) ->
    return unless visible
    
    $.getScript $(this).attr('href')