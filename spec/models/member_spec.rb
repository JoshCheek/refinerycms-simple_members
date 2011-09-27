require 'spec_helper'
require 'stringio'

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
  
  describe 'loading from csv' do
    let(:good_file) { StringIO.new <<-DATA.gsub(/^\s+/,'') }
      "Stewart","John",973
      "Kelly","Megyn",833
    DATA
    
    let(:bad_file) { StringIO.new <<-DATA.gsub(/^\s+/,'') }
      "Stewart","John",973
      "Hannity","Sean",
      "Maddow","Rachel",
      "Kelly","Megyn",833
    DATA
    
    def capture_stderr
      initial_stderr = $stderr
      $stderr = new_stderr = StringIO.new
      yield
      new_stderr.rewind
      new_stderr.read
    ensure
      $stderr = initial_stderr
    end
    
    it 'takes files where each line is last_name, first_name, unique_identifier' do
      Member.populate_from_csv good_file
      Member.all.map(&:first_name).should         == %w[John     Megyn]
      Member.all.map(&:last_name).should          == %w[Stewart  Kelly]
      Member.all.map(&:unique_identifier).should  == %w[973      833]
    end
    
    it 'does not repopulate records with an existing unique_identifier' do
      Member.create! :first_name => 'John', :last_name => 'Stewart', :unique_identifier => '973'
      capture_stderr { Member.populate_from_csv good_file }
      Member.all.map(&:unique_identifier).should == %w[973 833]
    end
    
    context 'when unique_identifier is missing' do
      it 'makes up a unique_identifier' do
        capture_stderr { Member.populate_from_csv bad_file }
        identifiers = Member.all.map(&:unique_identifier)
        identifiers.size.should == 4
        identifiers[0].should == '973'
        identifiers[1].should == '1'
        identifiers[2].should == '2'
        identifiers[3].should == '833'
      end
    
      it 'informs the user' do
        stderr = capture_stderr { Member.populate_from_csv bad_file }
        stderr.should =~ /Hannity/
        stderr.should =~ /Maddow/
        stderr.should_not =~ /Stewart/
        stderr.should_not =~ /Kelly/
      end
      
      context 'and script is run twice' do
        it 'does not put the missing user in twice' do
          capture_stderr { Member.populate_from_csv bad_file }
          capture_stderr { Member.populate_from_csv bad_file }
          Member.count.should == 4
        end
      end
    end
    
  end
end


