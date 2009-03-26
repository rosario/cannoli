class AddTotalActionsToVisitor < ActiveRecord::Migration
  def self.up
    add_column :visitors, :total_actions, :integer
  end

  def self.down
    remove_column :visitors, :total_actions
  end
end
