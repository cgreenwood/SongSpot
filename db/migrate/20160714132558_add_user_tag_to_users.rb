class AddUserTagToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_tag, :string
  end
end
