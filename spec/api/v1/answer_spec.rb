require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/answers/id' do
    let(:answer) { create(:answer, user: create(:user)) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, user: create(:user), commentable: answer) }
      let!(:links) { create_list(:link, 3, linkable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end
      
      it 'returns public field' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { json['answer']['comments'].first }

        it 'returns list of comments' do
          expect(json['answer']['comments'].size).to eq 3
        end

        it 'returns public field' do
          %w[id body user_id commentable_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { json['answer']['links'].first }

        it 'returns list of links' do
          expect(json['answer']['links'].size).to eq 3
        end

        it 'returns public field' do
          expect(link_response['url']).to eq link.url
        end
      end
    end
  end
  
  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end
    
    context 'authorize' do
      let(:access_token) { create(:access_token) }
      
      it 'returns 200 status' do
        post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, answer: { body: 'MyBody' } }, headers: headers
        expect(response).to be_successful
      end

      describe 'with valid attributes' do
        
        it 'new answer object' do
          expect{ post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, answer: { body: 'MyBody' } }, headers: headers }.to change(Answer, :count).by(1)
        end

        it 'returns title and body new object' do
          post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, answer: { body: 'MyBody' } }, headers: headers
          expect(json['answer']['body']).to eq 'MyBody'
        end
      end

      describe 'with invalid attributes' do
        
        it 'new answer object' do
          expect{ post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, answer: { body: nil } }, headers: headers }.to_not change(Answer, :count)
        end
      end 
    end
  end

  describe "/api/v1/answers/:id" do
    let(:answer) { create(:answer, user: me) }
    let(:me) { create(:user) }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      describe 'with valid attributes' do
        before { patch "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token, answer: { body: 'UpdatedBody' } }, headers: headers }

        it 'returns 200 status' do
          expect(response).to be_successful
        end
        
        it 'returns title and body updated object' do
          expect(json['answer']['body']).to eq 'UpdatedBody'
        end 
      end   
      
      describe 'with invalid attributes' do

        #it 'returnd title and body not updated object' do
          #patch ""/api/v1/answers/#{answer.id}"", params: { access_token: access_token.token, answer: { body: nil } }, headers: headers          
          #expect(json['answer']['body']).to eq 'MyText'
        #end 
      end

      describe 'not author tried update' do

        let(:other_answer) { create(:answer, user: create(:user)) } 

        it 'returnd title and body not updated object' do
          patch "/api/v1/answers/#{other_answer.id}", params: { access_token: access_token.token, answer: { body: 'MyBody' } }, headers: headers          
          expect(json['answer']['body']).to eq 'MyAnswer'
        end 
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do

    let!(:answer) { create(:answer, user: me) }
    let(:me) { create(:user) }


    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      it 'returns 200 status' do
        delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end

      describe 'current user author' do

        it 'delete answer' do
          expect{ delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }.to change(Answer, :count).by(-1)
        end
      end

      describe 'current user not author' do
        let!(:other_answer) { create(:answer, user: create(:user)) } 

        it 'not delete answer' do
          expect{ delete "/api/v1/answers/#{other_answer.id}", params: { access_token: access_token.token }, headers: headers }.to_not change(Answer, :count)
        end
      end
    end
  end
end
