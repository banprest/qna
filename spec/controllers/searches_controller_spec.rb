require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe 'GET #search' do

    let(:params) { { query: '123', type: 'Question' } }

    it 'render template search', sphinx: true, js: true do

      ThinkingSphinx::Test.run do
        get :search, params: params
        expect(response).to render_template :search
      end
    end

    it 'service call', sphinx: true, js: true do 
      ThinkingSphinx::Test.run do
        allow(SearchService.new(params)).to receive(:call)
        get :search, params: params
      end
    end
  end
end
