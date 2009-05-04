class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.integer :visitor_id
      t.integer :action_id

      t.timestamps
    end
  end

  def self.down
    drop_table :visits
  end
end
