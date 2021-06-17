require 'rails_helper'

RSpec.describe AddAnswerMailJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  let(:service) { double('AddAnswerMail') }

  before do
    allow(AddAnswerMail).to receive(:new).and_return(service)
  end

  it 'calls AddAnswerMailt#send_digest' do
    expect(service).to receive(:send_digest).with(user, question)
    AddAnswerMailJob.perform_now(user, question)
  end
end
