class AddAnswerMailJob < ApplicationJob
  queue_as :default

  def perform(user, question)
    AddAnswerMail.new.send_digest(user, question)
  end
end
