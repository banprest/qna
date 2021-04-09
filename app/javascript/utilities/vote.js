$(document).on('turbolinks:load', function(){
  $('.question-rating').on('ajax:success', function(e){
    
    var id = e.detail[0].id
    var rating = e.detail[0].rating

    $('.rating-' + id).html('<p> Rating: ' + rating + '<p>')
  })
})
