class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.timestamps
    end
    add_index :permissions, :slug, unique: true
  end
end
