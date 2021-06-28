class SearchesController < ApplicationController

  authorize_resource

  def search
    @objects = SearchService.new(searched_params).call
  end

  private

  def searched_params
    params.permit(:query, :type)
  end
end
