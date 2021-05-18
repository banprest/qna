require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: create(:user)) }
      let(:object) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, user: create(:user), question: object) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }
      
      it_behaves_like 'API object' do
        let(:json_object) { question_response }
        let(:value) { %w[id title body created_at updated_at ] }
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq object.title.truncate(7)
      end
      
      it_behaves_like 'API answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'] }
      end
    end
  end

  describe 'GET /api/v1/questions/id' do

    let!(:object) { create(:question, user: create(:user)) }
    let!(:answers) { create_list(:answer, 3, user: create(:user), question: object) }
    let!(:comments) { create_list(:comment, 3, user: create(:user), commentable: object) }
    let!(:links) { create_list(:link, 3, linkable: object) }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{object.id}" }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      before { get "/api/v1/questions/#{object.id}", params: { access_token: access_token.token }, headers: headers }
      
      it_behaves_like 'API object' do
        let(:json_object) { json['question'] }
        let(:value) { %w[id title body created_at updated_at ] }
      end

      it_behaves_like 'API answers' do
        let(:answer) { answers.first }
        let(:answer_response) { json['question']['answers'] }
      end

      it_behaves_like 'API comments' do
        let(:comment) { comments.first }
        let(:comment_response) { json['question']['comments']}
      end

      it_behaves_like 'API links' do
        let(:link) { links.first }
        let(:link_response) { json['question']['links']}
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API POST' do
      let(:access_token) { create(:access_token) }
      let(:object_params) { { title: 'MyString', body: 'MyBody' } }
      let(:params) { { access_token: access_token.token, 
                       question: object_params }  }
      let(:value) { [:title, :body] }
      let(:object) { Question }
      let(:params_other) { { access_token: access_token.token, 
                       question: { title: nil, body: nil } }  }
    end
  end

  describe 'PATCH /api/v1/questions' do

    let(:me) { create(:user) }
    let!(:object) { create(:question, user: me) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{object.id}" }

    it_behaves_like 'API Authorizable' 

    it_behaves_like 'API PATH' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:object_params) { { title: 'UpdatedTitle', body: 'UpdatedBody' } }
      let(:params) { { access_token: access_token.token, 
                       question: object_params }  }
      let(:value) { [:title, :body] }
      let(:other_object) { create(:question) }
      let(:api_path_other) { "/api/v1/questions/#{other_object.id}" } 
      let(:params_invalid) { { access_token: access_token.token, 
                       question: { title: nil, body: nil } }  }
    end
  end

  describe 'DELETE /api/v1/questions' do

    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:other_question) { create(:question, user: create(:user)) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{question.id}" }


    it_behaves_like 'API Authorizable'

    it_behaves_like 'API DELETE' do
      let(:api_path_other) { "/api/v1/questions/#{other_question.id}" }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:object) { Question } 
    end
  end
end
