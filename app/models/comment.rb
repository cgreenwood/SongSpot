# Comment model which defines relations
class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
end
