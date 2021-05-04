class AttachmentsController < ApplicationController

  skip_authorization_check
  
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @object = @file.record
    @file.purge if current_user.author?(@object)
    if @object.is_a?(Question)
      redirect_to question_path(@object)
    else
      @question = @object.question
    end
  end
end
