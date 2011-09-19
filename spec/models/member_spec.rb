require 'spec_helper'

describe 'Members' do
  before(:each) { Member.delete_all }
  specify 'have a first_name last_name email and unique_identifier' do
    -> { 
      Member.create! :first_name => 'Clara', :last_name => 'Jones', :email => 'cjones@gmail.com', :unique_identifier => 'A3X9'
    }.should_not raise_error
    clara = Member.first
    clara.first_name.should == 'Clara'
    clara.last_name.should == 'Jones'
    clara.email.should == 'cjones@gmail.com'
    clara.unique_identifier.should == 'A3X9'
  end
  
  specify 'can be created with only a unique_identifier' do
    -> { Member.create! :unique_identifier => 'C93P' }.should_not raise_error
    member = Member.first
    member.first_name.should be_nil
    member.last_name.should be_nil
    member.email.should be_nil
    member.unique_identifier.should == 'C93P'
  end
  
  specify 'cannot be created without a unique number' do
    -> { Member.create! :first_name => 'Clara', :last_name => 'Jones', :email => 'cjones@gmail.com' }.should raise_error
  end
  
  specify 'unique_identifier must be unique' do
    abe = Member.new :first_name => 'Abe', :last_name => 'Lincoln', :email => 'potus@whitehouse.gov', :unique_identifier => 'AAAA'
    jim = Member.new :first_name => 'Jim', :last_name => 'Beam',    :email => 'yay@happytime.com'   , :unique_identifier => 'AAAA'
    -> { abe.save! }.should_not raise_error
    -> { jim.save! }.should raise_error
  end
end


