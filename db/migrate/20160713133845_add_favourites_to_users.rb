class AddFavouritesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :favourites, :string
  end
end
