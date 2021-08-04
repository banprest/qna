class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question, touch: true
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  
  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  after_create :digest_for_new_answer

  def mark_as_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update!(best: true)
      question.reward&.update!(user_id: self.user_id)
    end
  end

  private

  def digest_for_new_answer
    AddAnswerMailJob.perform_later(self.question)
  end
end
