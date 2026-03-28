class CreateTransitionLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :transition_logs do |t|
      t.references :workflow_instance, null: false, foreign_key: true
      t.string :from_state, null: false
      t.string :to_state, null: false
      t.integer :transitioned_by_id
      t.jsonb :data, default: {}
      t.timestamps
    end
  end
end
