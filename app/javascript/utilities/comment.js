$(document).on('turbolinks:load', function(){
  $('.comments').on('click', '.create-comment-link', function(e) {
    e.preventDefault()
    $(this).hide()
    var resourceId = $(this).data('resourceId')
    $('form#new-comment-' + resourceId).removeClass('hidden')
  })
})
