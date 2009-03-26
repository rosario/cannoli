class AddLastActionTimeToVisitor < ActiveRecord::Migration
  def self.up
    add_column :visitors, :last_action_time, :datetime
  end

  def self.down
    remove_column :visitors, :last_action_time
  end
end
