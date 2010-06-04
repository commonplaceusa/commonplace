$(document).ready(function(){
    $(window).bind('hashchange', function () {
        var url = window.location.hash.slice(1);

        $.ajax({
            url: url,
            dataType: 'script',
            type: "GET",
            beforeSend: function (xhr) {
        
            },
            success: function (data, status, xhr) {
        
            },
            complete: function (xhr) {
        
            },
            error: function (xhr, status, error) {
        
            }
        });
        
    });
    
    if (window.location.hash) {$(window).trigger('hashchange');}
    
    $("label.in-field").inFieldLabels({fadeOpacity:0});
    $(".replies").hide();
    $("a.show_replies").live('click', function(){
        $(this).siblings(".replies").slideToggle(300);
        return false;
    });
    $("#submission button").live('click',function() {
        $(this.form).append("<input type='hidden' name='commit' value='"+$(this).attr("value")+"'\>");
    });
});
