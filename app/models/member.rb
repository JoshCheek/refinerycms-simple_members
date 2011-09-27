class Member < ActiveRecord::Base

  acts_as_indexed :fields => [:first_name, :last_name, :email, :unique_identifier]

  validates :unique_identifier, :presence => true, :uniqueness => true
  
  def self.populate_from_csv(file)
    require 'csv'
    CSV.new(file).each do |last_name, first_name, unique_identifier|
      if unique_identifier.nil?
        $stderr.puts "Omiting #{first_name}, #{last_name} as their unique_identifier is missing"
      else
        Member.create :first_name => first_name, :last_name => last_name, :unique_identifier => unique_identifier
      end
    end
  end
  
end

