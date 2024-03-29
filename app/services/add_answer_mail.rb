class AddAnswerMail

  def send_digest(question)
    Subscription.where(question_id: question.id).each do |sub|
      NewAnswerMailer.digest(sub.user, question).deliver_later
    end
  end
end
