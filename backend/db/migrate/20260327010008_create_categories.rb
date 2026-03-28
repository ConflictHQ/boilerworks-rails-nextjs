class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.integer :parent_id
      t.string :uuid
      t.datetime :deleted_at
      t.integer :created_by_id
      t.integer :updated_by_id
      t.integer :deleted_by_id
      t.integer :lock_version
      t.timestamps
    end
  end
end
