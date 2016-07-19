# Article model where relations are
class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
                    length: { minimum: 5, maximum: 128 }
  validates :text, presence: true, length: { maximum: 5000 }
  validates_associated :user
end
