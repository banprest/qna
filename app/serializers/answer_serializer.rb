class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at, :created_at
  has_many :comments
  has_many :links
  belongs_to :question
  belongs_to :user
end
