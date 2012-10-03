
refresh_pic = () ->
    data = null
    $('.photo_info').stop().fadeOut 'fast'
    $('.photo_frame').stop().fadeOut 'fast', () ->
        $.getJSON 'refresh', (data) ->
            $('#photo_left').attr('src',
                                  'data:image/jpeg;base64,'+data.pic_left.data)
                            .val(data.pic_left.id)
                            .parent().parent()
                            .find('.photo_info')
                            .text(data.pic_left.info)

            $('#photo_right').attr('src',
                                  'data:image/jpeg;base64,'+data.pic_right.data)
                             .val(data.pic_right.id)
                             .parent().parent()
                             .find('.photo_info')
                             .text(data.pic_right.info)

            $('.photo_frame').fadeIn 'slow'


vote_up = (id) ->
    $.ajax
        type: 'POST',
        url: 'vote',
        data: { 'id': id }


$ ->
    $(document).keydown (e) ->
        switch e.which
            when 37 # left arrow
                $('#photo_left').click()
            when 39 # right arrow
                $('#photo_right').click()

    $('.photo_frame').click (who) ->
        $(who.target).parent().parent().find('.voted')
            .fadeIn 'fast', () ->
                $(this).fadeOut 'slow'
        vote_up($(who.target).val())
        refresh_pic()

    $('.photo_frame').hover (e) ->
        $(e.target).css 'cursor', 'pointer'
        $(e.target).parent().parent().find('div.photo_info').fadeIn('slow')
    , (e) ->
        $(e.target).css 'cursor', 'default'
        $(e.target).parent().parent().find('div.photo_info').fadeOut('fast')

    $(document).ready () ->
        refresh_pic()

