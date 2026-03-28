class CreateFormSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :form_submissions do |t|
      t.references :form_definition, null: false, foreign_key: true
      t.jsonb :data, null: false, default: {}
      t.string :status, null: false, default: "draft"
      t.integer :submitted_by_id
      t.datetime :validated_at
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
