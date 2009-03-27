class RemoveVisitorIdFromAction < ActiveRecord::Migration
  def self.up
    remove_column :actions, :visitor_id
  end

  def self.down
    add_column :actions, :visitor_id, :integer
  end
end
