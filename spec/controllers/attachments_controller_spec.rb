require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:user1) { create(:user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'DELETE #destroy' do

    let(:user1) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Author delete answer file' do
      before { login(user) }
      
      it 'delete file' do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
        
        expect { delete :destroy, params: { id: answer.files[0].id }, format: :js }.to change(answer.files, :count).by(-1)
      end

      it 'render destroy' do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
        delete :destroy, params: { id: answer.files[0].id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Author delete question file' do
      before { login(user) }
      
      it 'delete file' do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
        
        expect { delete :destroy, params: { id: question.files[0].id } }.to change(question.files, :count).by(-1)
      end

      it 'render destroy' do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
        delete :destroy, params: { id: question.files[0].id }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Not author delete question file' do
      before { login(user1) }
      
      it 'tried delete file' do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
        
        expect { delete :destroy, params: { id: question.files[0].id } }.to_not change(question.files, :count)
      end

      it 'render destroy' do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
        delete :destroy, params: { id: question.files[0].id }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Not author tried delete answer file' do
      before { login(user1) }
      
      it 'tried delete file' do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
        
        expect { delete :destroy, params: { id: answer.files[0].id }, format: :js }.to_not change(answer.files, :count)
      end

      it 'render destroy' do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
        delete :destroy, params: { id: answer.files[0].id }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
