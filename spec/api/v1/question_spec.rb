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
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, user: create(:user), question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns public field' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
      
      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of questions' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns public field' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/id' do

    let!(:question) { create(:question, user: create(:user)) }
    let!(:answers) { create_list(:answer, 3, user: create(:user), question: question) }
    let!(:comments) { create_list(:comment, 3, user: create(:user), commentable: question) }
    let!(:links) { create_list(:link, 3, linkable: question) }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }
      
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns public field' do
        %w[id title body created_at updated_at ].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns user object' do
        expect(json['question']['user']['id']).to eq question.user.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { json['question']['answers'].first }

        it 'returns list of answer' do
          expect(json['question']['answers'].size).to eq 3
        end

        it 'returns public field' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { json['question']['comments'].first }

        it 'returns list of comments' do
          expect(json['question']['comments'].size).to eq 3
        end

        it 'returns public field' do
          %w[id body user_id commentable_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { json['question']['links'].first }

        it 'returns list of links' do
          expect(json['question']['links'].size).to eq 3
        end

        it 'returns public field' do
          expect(link_response['url']).to eq link.url
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { "/api/v1/questions" }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      
      it 'returns 200 status' do
        post "/api/v1/questions", params: { access_token: access_token.token, question: { title: 'MyString', body: 'MyBody' } }, headers: headers
        expect(response).to be_successful
      end

      describe 'with valid attributes' do
        
        it 'new question object' do
          expect{ post "/api/v1/questions", params: { access_token: access_token.token, question: { title: 'MyString', body: 'MyBody' } }, headers: headers }.to change(Question, :count).by(1)
        end

        it 'returns title and body new object' do
          post "/api/v1/questions", params: { access_token: access_token.token, question: { title: 'MyString', body: 'MyBody' } }, headers: headers
          expect(json['question']['title']).to eq 'MyString'
          expect(json['question']['body']).to eq 'MyBody'
        end
      end

      describe 'with invalid attributes' do
        
        it 'new question object' do
          expect{ post "/api/v1/questions", params: { access_token: access_token.token, question: { title: nil, body: nil } }, headers: headers }.to_not change(Question, :count)
        end
      end   
    end
  end

  describe 'PATCH /api/v1/questions' do

    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      describe 'with valid attributes' do
        before { patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, question: { title: 'UpdatedTitle', body: 'UpdatedBody' } }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end
        
        it 'returns title and body updated object' do
          expect(json['question']['title']).to eq 'UpdatedTitle'
          expect(json['question']['body']).to eq 'UpdatedBody'
        end 
      end   
      
      describe 'with invalid attributes' do

        #it 'returnd title and body not updated object' do
          #patch "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, question: { title: nil, body: nil } }, headers: headers          
          #expect(json['question']['title']).to eq 'MyString'
          #expect(json['question']['body']).to eq 'MyText'
        #end 
      end

      describe 'not author tried update' do

        let(:other_question) { create(:question, user: create(:user)) } 

        it 'returnd title and body not updated object' do
          patch "/api/v1/questions/#{other_question.id}", params: { access_token: access_token.token, question: { title: 'UpdatedTitle', body: 'UpdatedBody' } }, headers: headers          
          expect(json['question']['title']).to eq 'MyString'
          expect(json['question']['body']).to eq 'MyText'
        end 
      end
    end
  end

  describe 'DELETE /api/v1/questions' do

    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:other_question) { create(:question, user: create(:user)) }


    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    it_behaves_like 'API DELETE' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:api_path_other) { "/api/v1/questions/#{other_question.id}" }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:object) { Question } 
    end
  end
end
