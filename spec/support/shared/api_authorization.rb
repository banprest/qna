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

shared_examples_for 'API PATH' do

  context 'authorize' do
    describe 'with valid attributes' do
      before { do_request(method, api_path, params: params , headers: headers) }

      it 'returns 200 status' do
        expect(response).to be_successful
      end
      
      it 'returns title and body updated object' do
        value.each do |attr|
          expect(json[object.class.to_s.downcase][attr.to_s]).to eq object_params[attr]
        end
      end 
    end   
    
    describe 'with invalid attributes' do

      before { do_request(method, api_path, params: params_invalid , headers: headers) }

      it 'returnd 422 status' do
        expect(response.status).to eq 422
      end

      it 'returns errors' do
        value.each do |attr|
          expect(json[attr.to_s]).to eq ["can't be blank"]
        end
      end
    end
  end
end

shared_examples_for 'API POST' do
  context 'authorize' do
    it 'returns 200 status' do
      do_request(method, api_path, params: params, headers: headers)
      expect(response).to be_successful
    end

    describe 'with valid attributes' do
      
      it 'new object' do
        expect{ do_request(method, api_path, params: params, headers: headers) }.to change(object, :count).by(1)
      end

      it 'returns title and body new object' do
        do_request(method, api_path, params: params, headers: headers)
        value.each do |attr|
          expect(json[object.to_s.downcase][attr.to_s]).to eq object_params[attr]
        end
      end
    end

    describe 'with invalid attributes' do
      
      it 'new not save object' do
        expect{ do_request(method, api_path, params: params_other, headers: headers) }.to_not change(object, :count)
      end

      it 'return 422 status' do
        do_request(method, api_path, params: params_other , headers: headers)
        expect(response.status).to eq 422
      end

      it 'returns errors' do
        do_request(method, api_path, params: params_other , headers: headers)
        value.each do |attr|
          expect(json[attr.to_s]).to eq ["can't be blank"]
        end
      end
    end 
  end
end

shared_examples_for 'API links' do
  describe 'links' do
    it 'returns list of links' do
      expect(link_response.size).to eq 3
    end

    it 'returns public field' do
      expect(link_response.first['url']).to eq link.url
    end
  end
end

shared_examples_for 'API comments' do
  describe 'comments' do
    it 'returns list of comments' do
      expect(comment_response.size).to eq 3
    end

    it 'returns public field' do
      %w[id body user_id commentable_id created_at updated_at].each do |attr|
        expect(comment_response.first[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end

shared_examples_for 'API answers' do
  describe 'answers' do
    it 'returns list of answer' do
      expect(answer_response.size).to eq 3
    end

    it 'returns public field' do
      %w[id body created_at updated_at].each do |attr|
        expect(answer_response.first[attr]).to eq answer.send(attr).as_json
      end
    end
  end
end

shared_examples_for 'API object' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
  
  it 'returns public field' do
    value.each do |attr|
      expect(json_object[attr]).to eq object.send(attr).as_json
    end
  end

  it 'returns user object' do
    expect(json_object['user']['id']).to eq object.user.id
  end
end

shared_examples_for 'API profile' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end

  it 'returns all public fields' do
    %w[id email admin created_at updated_at].each do |attr|
      expect(json_object[attr]).to eq user.send(attr).as_json
    end
  end

  it 'not returns private fields' do
    %w[password encrypted_password ].each do |attr|
      expect(json_object).to_not have_key(attr)
    end
  end
end
