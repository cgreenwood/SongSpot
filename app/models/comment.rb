# Comment model which defines relations
class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  validates :body, presence: true, length: { maximum: 255 }
end
