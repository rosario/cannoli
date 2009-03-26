class AddWasHereToVisitor < ActiveRecord::Migration
  def self.up
    add_column :visitors, :was_here, :integer
  end

  def self.down
    remove_column :visitors, :was_here
  end
end
