require 'rails_helper'

RSpec.describe AddAnswerMail do
  let(:questions) { create_list(:question,3) }
  
  it 'sends digest' do
    questions.each do |question|
      question.subscriptions.each { |sub| expect(NewAnswerMailer).to receive(:digest).with(sub.user, question).and_call_original }
      subject.send_digest(question)
    end
  end
end
