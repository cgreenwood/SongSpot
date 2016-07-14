# Makes Bug database with following rows.
class CreateBugs < ActiveRecord::Migration[5.0]
  def change
    create_table :bugs do |t|
      t.string :title
      t.string :type
      t.text :content
      t.timestamps
    end
  end
end
