import consumer from "./consumer"

consumer.subscriptions.create({channel: "CommentChannel", question_id: gon.question_id}, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const Handlebars = require("handlebars");
    var source = ('<div class="comment"><p>{{email}}</p><p>{{comment.body}}</p></div>')
    var template = Handlebars.compile(source);
    var id = data.id
    $('#' + data.comment.commentable_type + '-' + data.comment.commentable_id + '-comments').append(template(data))
  }
});
