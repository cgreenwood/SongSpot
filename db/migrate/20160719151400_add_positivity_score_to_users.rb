class AddPositivityScoreToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :positivity_score, :float
  end
end
