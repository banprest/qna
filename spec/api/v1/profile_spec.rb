require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorize' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }
      
      it_behaves_like 'API profile' do
        let(:json_object) { json['user'] }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorize' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 3)}
      let(:user) { users.first }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }
      
      it_behaves_like 'API profile' do
        let(:json_object) { json['users'].first }
      end

      it 'returns list' do
        expect(json['users'].size).to eq 3
      end

      it 'not return current_user' do
        expect(json['users']).to_not include(me)
      end
    end
  end
end
