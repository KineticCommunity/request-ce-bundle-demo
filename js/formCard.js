
$(function() {
    $('.star-existing').each(function(){
        $(this).starrr({
            rating: $(this).data('rating'),
            readOnly: true
        });
    });

    $('.star-new').each(function(){
        $(this).starrr({
            change: function(e, value){
                // Set Hidden Value Question
                $(this).next().val(value);
            }
        });
    });

    // Function used for Creating New Reviews on Services
    $('.createReview').on('click', function(){
        $that = $(this);
        var review = $(this).parent().prev().val(),
            slug = $(this).parent().parent().parent().find('.slug').val(),
            name = $(this).parent().parent().parent().find('.name').val(),
            rating = $(this).parent().parent().parent().find('.rating').val(),
            payload = JSON.stringify({"values": {"Review":review,"Rating":rating,"Form Slug":slug,"Form Name":name}});

        if(rating === ""){
            alert('Please make sure to choose a Star Rating');
        } else {
        $.ajax({
            method: 'POST',
            url: 'app/api/v1/kapps/' + bundle.kappSlug() + '/forms/service-reviews/submissions',
            dataType: "json",
            data:   payload,
            contentType: "application/json",

            // If form creation was successful run this code
            success: function(response, textStatus, jqXHR){
                var success = $('<div class="box-comment"/>')
                        .append($('<div class="comment-text">').html('Thanks for your review. It has been successfully added...'));
                $that.parents('form').replaceWith(success);
            },
            // If there was an error, show the error
            error: function(jqXHR, textStatus, errorThrown){
                var error = $('<div class="box-comment"/>')
                        .append($('<div class="comment-text">').html('There was an issue submitting your review. Please try again later...'));
                $that.parents('form').replaceWith(error);
            }
        });
        }
    });
});