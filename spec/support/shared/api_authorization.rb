shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there no access token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end
    it 'returns 401 status if access token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'API DELETE' do
  context 'authorize' do
      
    it 'returns 200 status' do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(response).to be_successful
    end

    describe 'current user author' do

      it 'delete object' do
        expect{ do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }.to change(object, :count).by(-1)
      end
    end

    describe 'current user not author' do 
      it 'not delete object' do
        expect{ do_request(method, api_path_other, params: { access_token: access_token.token }, headers: headers) }.to_not change(object, :count)
      end
    end
  end
end
