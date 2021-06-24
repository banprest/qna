require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe 'GET #search' do

    it 'render template search', sphinx: true, js: true do

      ThinkingSphinx::Test.run do
        get :search, params: { query: '123', type: 'Question' }
        expect(response).to render_template :search
      end
    end
  end
end
