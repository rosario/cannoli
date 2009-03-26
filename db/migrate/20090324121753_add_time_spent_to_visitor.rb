class AddTimeSpentToVisitor < ActiveRecord::Migration
  def self.up
    add_column :visitors, :time_spent, :integer
  end

  def self.down
    remove_column :visitors, :time_spent
  end
end
