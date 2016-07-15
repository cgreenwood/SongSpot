class AddBugStatusToBugs < ActiveRecord::Migration[5.0]
  def change
    add_column :bugs, :bug_status, :string, default: 'Pending'
  end
end
