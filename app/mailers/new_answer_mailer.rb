class NewAnswerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_mailer.digest.subject
  #
  def digest(user, question)
    @question = question

    mail to: user.email
  end
end
