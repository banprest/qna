require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :question }

  it { should validate_presence_of :reward_title }
  it { should validate_presence_of :image }
end
