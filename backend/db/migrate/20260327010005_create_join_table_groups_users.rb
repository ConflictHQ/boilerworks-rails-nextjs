class CreateJoinTableGroupsUsers < ActiveRecord::Migration[8.0]
  def change
    create_join_table :groups, :users
  end
end
