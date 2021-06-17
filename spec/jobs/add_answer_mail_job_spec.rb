require 'rails_helper'

RSpec.describe AddAnswerMailJob, type: :job do
  let(:question) { create(:question) }

  let(:service) { double('AddAnswerMail') }

  before do
    allow(AddAnswerMail).to receive(:new).and_return(service)
  end

  it 'calls AddAnswerMailt#send_digest' do
    expect(service).to receive(:send_digest).with(question)
    AddAnswerMailJob.perform_now(question)
  end
end
