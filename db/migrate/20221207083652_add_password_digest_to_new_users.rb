class AddPasswordDigestToNewUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :new_users, :password_digest, :string
    end
end
