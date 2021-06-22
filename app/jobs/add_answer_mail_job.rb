class AddAnswerMailJob < ApplicationJob
  queue_as :default

  def perform(question)
    AddAnswerMail.new.send_digest(question)
  end
end
