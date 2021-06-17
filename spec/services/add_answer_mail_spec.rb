require 'rails_helper'

RSpec.describe AddAnswerMail do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:subscriptions) { create_list(:subscription, 3, question: question, user: user) }

  it 'sends digest' do
    subscriptions.each { |sub| expect(NewAnswerMailer).to receive(:digest).with(sub.user, question).and_call_original }
    subject.send_digest(question)
  end
end
