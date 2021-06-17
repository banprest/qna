class AddAnswerMail

  def send_digest(user, question)
    NewAnswerMailer.digest(user, question).deliver_later
  end
end
