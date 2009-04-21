class Click < ActiveRecord::Base
  belongs_to :visitor
  belongs_to :action
end
