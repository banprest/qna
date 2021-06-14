shared_examples_for 'POST create' do
 describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new object in the database' do 
        expect { post :create, params: params }.to change(object, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the object' do
        expect { post :create, params: invalid_params }.to_not change(object, :count)
      end

      it 're-renders new view' do 
        post :create, params: invalid_params
        expect(response).to render_template template
      end
    end
  end
end

shared_examples_for 'PATCH update' do
  context 'with valid attributes' do
    it 'changes object attributes' do
      patch :update, params: params
      object.reload

      value.each do |attr|
        expect(object[attr]).to eq object_value[attr]
      end    
    end
    it 'redirects to update object' do
      patch :update, params: params
      expect(response).to render_template template
    end
  end

  context 'with invalid attributes' do
    before { patch :update, params: invalid_params }    
    it 'does not change object' do
      object.reload

      value.each do |attr|
        expect(object[attr]).to eq object[attr]
      end
    end
    it 're-rendre edit update' do
      expect(response).to render_template template
    end
  end
end

shared_examples_for 'DELETE destroy' do

  context 'Author delete object' do
    before { login(user) }

    it 'delete object' do
      expect { delete :destroy, params: params }.to change(object, :count).by(-1)
    end
    it 'redirect_to object_path' do
      delete :destroy, params: params
      expect(response).to redirect_path_author
    end
  end
  context 'Not author tried delete object' do
    before { login(user1) }

    it 'delete object' do
      expect { delete :destroy, params: params }.to_not change(object, :count)
    end

    it 'redirect_to show' do
      delete :destroy, params: params
      expect(response).to redirect_path_not_author
    end
  end

  context 'Unauthenticated user tried delete object' do
    
    it 'delete object' do
      expect { delete :destroy, params: params }.to_not change(object, :count)
    end

    it 'redirects to sign_in' do
      delete :destroy, params: params
      expect(response).to redirect_path_unauth
    end
  end
end
