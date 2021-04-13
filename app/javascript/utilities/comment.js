$(document).on('turbolinks:load', function(){
  $('.comments').on('click', '.create-comment-link', function(e) {
    e.preventDefault()
    $(this).hide()
    $('.new-comment').removeClass('hidden')
  })
})
