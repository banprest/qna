class AttachmentsController < ApplicationController

  def destroy
    @file = ActiveStorage::Blob.find_signed(params[:id])
    @variable = @file.attachments.first.record
    @file.attachments.first.purge if current_user.author?(@variable)
    if @variable.class == Question
      redirect_to question_path(@variable)
    else
      @question = @variable.question
    end
  end
end
