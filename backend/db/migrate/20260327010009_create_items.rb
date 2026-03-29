class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :slug
      t.integer :category_id
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
