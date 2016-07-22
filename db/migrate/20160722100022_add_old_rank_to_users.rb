class AddOldRankToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :old_rank, :integer
  end
end
