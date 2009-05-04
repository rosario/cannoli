class RemoveReturningFromVisitor < ActiveRecord::Migration
  def self.up
    remove_column :visitors, :returning
  end

  def self.down
    add_column :visitors, :returning, :integer
  end
end
