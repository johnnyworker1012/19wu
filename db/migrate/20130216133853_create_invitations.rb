class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :code 
      t.boolean :activated, :default => false
      t.references :user

      t.timestamps
    end
    add_index :invitations, :user_id
  end
end
