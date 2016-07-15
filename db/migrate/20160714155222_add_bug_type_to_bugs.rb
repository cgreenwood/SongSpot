class AddBugTypeToBugs < ActiveRecord::Migration[5.0]
  def change
    add_column :bugs, :bug_type, :string
  end
end
