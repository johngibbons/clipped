jQuery ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_items_url = $('.pagination a.next_page').attr('href')
      if more_items_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
        $('.pagination').html('<img src="https://s3-us-west-2.amazonaws.com/entourageapp/images/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $.getScript more_items_url
      return
    return
