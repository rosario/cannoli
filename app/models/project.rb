# A project is associated with a website. ( A rename to Website should be done!)
class Project < ActiveRecord::Base
  has_many :users
  has_many :visitors
end
