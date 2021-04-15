import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    $('#' + data.comment.commentable_type + '-comments').append('<p>' + data.user_email + '</p>' + '<p>' + data.comment.body + '</p>')
  }
});
