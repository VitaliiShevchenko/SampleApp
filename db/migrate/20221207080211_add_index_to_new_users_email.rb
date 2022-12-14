class AddIndexToNewUsersEmail < ActiveRecord::Migration[7.0]
  def change
    add_index :new_users, :email, unique: true
  end
end
