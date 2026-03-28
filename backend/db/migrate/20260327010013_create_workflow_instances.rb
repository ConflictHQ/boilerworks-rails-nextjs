class CreateWorkflowInstances < ActiveRecord::Migration[8.0]
  def change
    create_table :workflow_instances do |t|
      t.references :workflow_definition, null: false, foreign_key: true
      t.string :workflowable_type
      t.integer :workflowable_id
      t.string :current_state, null: false
      t.jsonb :metadata, default: {}
      t.string :uuid, index: { unique: true }
      t.datetime :deleted_at, index: true
      t.integer :created_by_id
      t.integer :updated_by_id
      t.integer :deleted_by_id
      t.integer :lock_version, default: 0
      t.timestamps
    end
    add_index :workflow_instances, [:workflowable_type, :workflowable_id]
  end
end
