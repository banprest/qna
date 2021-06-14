shared_examples_for 'POST vote_up' do
  describe 'POST #vote up' do
    describe 'Not Author' do
      let(:user1) { create(:user) }
      before { login(user1) }

      it 'create vote +1' do
        expect { post :vote_up, params: params }.to change(Vote, :count).by(1)
      end
    end
    
    describe 'Author' do
      it 'author tried create vote + 1' do
        login(user)
        expect { post :vote_up, params: params }.to_not change(Vote, :count)
      end
    end
  end
end

shared_examples_for 'POST vote_down' do
  describe 'POST #vote down' do
    describe 'Not Author' do
      let(:user1) { create(:user) }
      before { login(user1) }

      it 'create vote -1' do
        expect { post :vote_down, params: params }.to change(Vote, :count).by(1)
      end
    end
    describe 'Author' do
      it 'author tried create vote  -1' do
        login(user)
        expect { post :vote_down, params: params }.to_not change(Vote, :count)
      end
    end
  end
end

shared_examples_for 'POST cancel_vote' do
  describe 'POST #cancel vote' do
    describe 'Not Author' do
      let(:user1) { create(:user) }
      before { login(user1) }

      it 'cancel vote' do
        expect { post :cancel_vote, params: params }.to change(Vote, :count).by(-1)
      end
    end

    describe 'Author' do
      let(:user1) { create(:user) }
      before { login(user) }

      it 'Author tried cancel vote' do
        expect { post :cancel_vote, params: params }.to_not change(Vote, :count)
      end
    end
  end
end
