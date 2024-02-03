class DropUsers < ActiveRecord::Migration[7.1]
  def change
    drop_table :active_sessions
  end
end
