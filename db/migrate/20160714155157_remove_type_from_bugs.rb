class RemoveTypeFromBugs < ActiveRecord::Migration[5.0]
  def change
    remove_column :bugs, :type, :string
  end
end
