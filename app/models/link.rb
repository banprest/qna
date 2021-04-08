class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_format_of :url, with: URI.regexp

  def gist?
    self.url.include?('https://gist.github.com/')
  end
end
