class Member < ActiveRecord::Base

  acts_as_indexed :fields => [:first_name, :last_name, :email, :unique_identifier]

  validates :first_name, :presence => true, :uniqueness => true
  
end
