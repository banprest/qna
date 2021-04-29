class RewardsController < ApplicationController
  
  skip_authorization_check

  def index
    @rewards = current_user.rewards
  end
end
