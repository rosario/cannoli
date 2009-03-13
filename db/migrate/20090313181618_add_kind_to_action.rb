class AddKindToAction < ActiveRecord::Migration
  def self.up
    add_column :actions, :kind, :integer
  end

  def self.down
    remove_column :actions, :kind
  end
end
