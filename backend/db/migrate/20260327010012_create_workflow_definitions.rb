class CreateWorkflowDefinitions < ActiveRecord::Migration[8.0]
  def change
    create_table :workflow_definitions do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.text :description
      t.jsonb :states, null: false, default: []
      t.jsonb :transitions, null: false, default: []
      t.string :target_type
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
