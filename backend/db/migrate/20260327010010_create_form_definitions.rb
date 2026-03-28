class CreateFormDefinitions < ActiveRecord::Migration[8.0]
  def change
    create_table :form_definitions do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.text :description
      t.jsonb :schema, null: false, default: { fields: [] }
      t.jsonb :field_config, default: {}
      t.jsonb :logic_rules, default: []
      t.integer :version, null: false, default: 1
      t.string :status, null: false, default: "draft"
      t.string :uuid, index: { unique: true }
      t.datetime :deleted_at, index: true
      t.integer :created_by_id
      t.integer :updated_by_id
      t.integer :deleted_by_id
      t.integer :lock_version, default: 0
      t.timestamps
    end
  end
end
