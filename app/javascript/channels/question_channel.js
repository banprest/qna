import consumer from "./consumer"

consumer.subscriptions.create("QuestionChannel", {
  connected() {
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $(".questions-list").append(data)
  }
});
