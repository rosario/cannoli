class RemoveTypeFromAction < ActiveRecord::Migration
  def self.up
    remove_column :actions, :type
  end

  def self.down
    add_column :actions, :type, :integer
  end
end
