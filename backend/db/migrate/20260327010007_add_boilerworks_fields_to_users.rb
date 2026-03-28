class AddBoilerworksFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :uuid, :string
    add_column :users, :deleted_at, :datetime
    add_column :users, :created_by_id, :integer
    add_column :users, :updated_by_id, :integer
    add_column :users, :deleted_by_id, :integer
    add_column :users, :lock_version, :integer
  end
end
