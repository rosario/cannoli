class AddProjectIdToAction < ActiveRecord::Migration
  def self.up
    add_column :actions, :project_id, :integer
  end

  def self.down
    remove_column :actions, :project_id
  end
end
