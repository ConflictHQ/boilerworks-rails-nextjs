class CreateJoinTableGroupsPermissions < ActiveRecord::Migration[8.0]
  def change
    create_join_table :groups, :permissions
  end
end
