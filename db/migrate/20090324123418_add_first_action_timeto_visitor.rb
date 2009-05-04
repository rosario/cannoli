class AddFirstActionTimetoVisitor < ActiveRecord::Migration
  def self.up
    add_column :visitors, :first_action_time, :datetime
  end

  def self.down
    remove_column :visitors, :first_action_time
  end
end
