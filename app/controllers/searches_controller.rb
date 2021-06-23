class SearchesController < ApplicationController

  authorize_resource

  def search
    @objects = ThinkingSphinx.search ThinkingSphinx::Query.escape(searched_params[:query])
  end

  private

  def searched_params
    params.permit(:query)
  end
end
