require 'rails_helper'

RSpec.describe SearchService do
  let!(:questions) { create_list(:question, 3) }
  let(:params) { { query: 'MyString', type: 'Question' } }

  subject { service = SearchService.new(params) }

  it 'return questions' do
    ThinkingSphinx::Test.run do
      get :search, params: params
      expect(subject.call).to eq questions
    end
  end
  #Не совсем понимаю как протестировать этот сервис, когда запускаем сервис через этот контролер
  #как я это вижу: мне нужно вызвать экшен search и проверить что сервис возврощает коллекцию после поиска
end
