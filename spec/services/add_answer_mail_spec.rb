require 'rails_helper'

RSpec.describe AddAnswerMail do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it 'sends digest' do
    expect(NewAnswerMailer).to receive(:digest).with(user, question).and_call_original
    subject.send_digest(user, question)
  end
end
