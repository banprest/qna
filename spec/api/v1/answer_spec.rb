require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/answers/id' do
    let(:object) { create(:answer, user: create(:user)) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/answers/#{object.id}" }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, user: create(:user), commentable: object) }
      let!(:links) { create_list(:link, 3, linkable: object) }

      before { get "/api/v1/answers/#{object.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API object' do
        let(:json_object) { json['answer'] }
        let(:value) { %w[id body created_at updated_at ] }
      end

      it_behaves_like 'API comments' do
        let(:comment) { comments.first }
        let(:comment_response) { json['answer']['comments']}
      end

      it_behaves_like 'API links' do
        let(:link) { links.first }
        let(:link_response) { json['answer']['links'] }
      end
    end
  end
  
  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API POST' do
      let(:access_token) { create(:access_token) }
      let(:object_params) { { body: 'UpdatedBody' } }
      let(:params) { { access_token: access_token.token, 
                       answer: object_params }  }
      let(:value) { [:body] }
      let(:object) { Answer }
      let(:params_other) { { access_token: access_token.token, 
                       answer: { body: nil } }  }
    end
  end

  describe "PATCH /api/v1/answers/:id" do
    let(:object) { create(:answer, user: me) }
    let(:me) { create(:user) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/answers/#{object.id}" }
    
    it_behaves_like 'API Authorizable'

    it_behaves_like 'API PATH' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:object_params) { { body: 'UpdatedBody' } }
      let(:params) { { access_token: access_token.token, 
                       answer: object_params }  }
      let(:value) { [:body] }
      let(:other_object) { create(:answer, user: create(:user)) }
      let(:api_path_other) { "/api/v1/answers/#{other_object.id}" } 
      let(:params_invalid) { { access_token: access_token.token, 
                       answer: { body: nil } }  }
    end
  end

  describe 'DELETE /api/v1/answers/:id' do

    let!(:answer) { create(:answer, user: me) }
    let(:me) { create(:user) }
    let!(:other_answer) { create(:answer, user: create(:user)) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }


    it_behaves_like 'API Authorizable'

    it_behaves_like 'API DELETE' do
      let(:api_path_other) { "/api/v1/answers/#{other_answer.id}" }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:object) { Answer } 
    end
  end
end
