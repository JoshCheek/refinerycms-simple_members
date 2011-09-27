class Member < ActiveRecord::Base

  acts_as_indexed :fields => [:first_name, :last_name, :email, :unique_identifier]

  validates :unique_identifier, :presence => true, :uniqueness => true
end
