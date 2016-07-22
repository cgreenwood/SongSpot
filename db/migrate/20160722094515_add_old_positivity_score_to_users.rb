class AddOldPositivityScoreToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :old_positivity_score, :float
  end
end
