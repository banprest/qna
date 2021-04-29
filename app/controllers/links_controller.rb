class LinksController < ApplicationController
  
  authorize_resource
  
  def destroy
    @link = Link.find(params[:id])
    if current_user.author?(@link.linkable)
      @object = @link.linkable
      @link.destroy
    end
  end
end
