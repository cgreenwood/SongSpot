var elementPosition = $('#navigation').offset();

$(window).scroll(function(){
        if($(window).scrollTop() > elementPosition.top){
              $('#player').css('position','fixed').css('top','50');
        } else {
            $('#player').css('position','static');
        }
});
