import consumer from "./consumer"

consumer.subscriptions.create("AnswerChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (gon.user_id === data.answer.user_id) return
    const Handlebars = require("handlebars");
    var source = ("{{#if answer.best}}<p>'Best Answer'</p>{{/if}}<p>{{answer.body}}</p>"
      + "{{#if answer_link}}<div class='links'><p>Links:</p><ul>{{#each answer_link}}<li><a href='{{this.url}}'>{{this.name}}</a></li>{{/each}}</ul></div>{{/if}}")
    var template = Handlebars.compile(source);
    $('#question-' + data.answer.question_id + '.answers').append(template(data))
  }
});
// Я не смог победить handlebars он не рендерит мои шаблоны при коде:
// const Handlebars = require("handlebars");
// var source = require('template/answer.hbs')
// var template = Handlebars.compile(source)
// я получаю ошибку: Uncaught Error: Cannot find module 'templates/answer.hbs
