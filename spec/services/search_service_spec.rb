require 'rails_helper'

RSpec.describe SearchService do

  describe 'With valid' do

    shared_examples_for 'Search' do
      it "search" do
        ThinkingSphinx::Test.run do
          expect(class_name).to receive(:search).with('MyString')
          SearchService.new({ query: 'MyString', type: type }).call
        end
      end
    end
    
    it_behaves_like 'Search', sphinx: true, js: true do
      let(:class_name) { Question }
      let(:type) { class_name.to_s }
    end

    it_behaves_like 'Search', sphinx: true, js: true do
      let(:class_name) { Answer }
      let(:type) { class_name.to_s }
    end

    it_behaves_like 'Search', sphinx: true, js: true do
      let(:class_name) { User }
      let(:type) { class_name.to_s }
    end

    it_behaves_like 'Search', sphinx: true, js: true do
      let(:class_name) { Comment }
      let(:type) { class_name.to_s }
    end

    it_behaves_like 'Search', sphinx: true, js: true do
      let(:class_name) { ThinkingSphinx }
      let(:type) { 'all' }
    end
  end
  
  describe 'With Invalid' do

    it 'search with invalid' do
      ThinkingSphinx::Test.run do
        expect(ThinkingSphinx).to_not receive(:search).with('MyString')
        SearchService.new({ query: 'MyString', type: 'invalid' }).call
      end
    end
  end
end
