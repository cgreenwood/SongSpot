#
class Bug < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { minimum: 5, maximum: 128 }
  validates :content, presence: true, length: { minimum: 5, maximum: 5000 }
  validates :bug_type, presence: true
end
