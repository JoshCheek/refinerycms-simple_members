Given /^I have no members$/ do
  Member.delete_all
end

Given /^I (only )?have members "?([^\"]*)"?$/ do |only, identifiers|
  Member.delete_all if only
  identifiers.split(', ').each do |identifier|
    Member.create(:unique_identifier => identifier)
  end
end

Then /^I should have ([0-9]+) members?$/ do |count|
  Member.count.should == count.to_i
end

def create_member(init_hash)
  member = Member.new
  member.first_name        = init_hash['first_name']         if init_hash.has_key? 'first_name'
  member.last_name         = init_hash['last_name']          if init_hash.has_key? 'last_name'
  member.email             = init_hash['email']              if init_hash.has_key? 'email'
  member.unique_identifier = init_hash['unique_identifier']  if init_hash.has_key? 'unique_identifier'
  member.save!
end

Then /^I can create these members$/ do |members|
  members.hashes.each do |init_hash|
    create_member init_hash
  end
end

Then /^I cannot create these members$/ do |members|
  members.hashes.each do |init_hash|
    lambda { create_member init_hash }.should raise_error
  end
end
