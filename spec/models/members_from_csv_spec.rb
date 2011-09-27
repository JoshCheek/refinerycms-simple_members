require 'lib/members_from_csv'

describe MembersFromCSV do
  
  before(:each) { Member.delete_all }
  
  let(:good_file) { StringIO.new <<-DATA.gsub(/^\s+/,'') }
    "LAST NAME","FIRST NAME","FCC LICENSE"
    "Stewart","John",973
    "Kelly","Megyn",833
  DATA
  
  let(:bad_file) { StringIO.new <<-DATA.gsub(/^\s+/,'') }
    "LAST NAME","FIRST NAME","AMA #"
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
    MembersFromCSV.populate good_file
    Member.all.map(&:first_name).should         == %w[John     Megyn]
    Member.all.map(&:last_name).should          == %w[Stewart  Kelly]
    Member.all.map(&:unique_identifier).should  == %w[973      833]
  end
  
  it 'does not repopulate records with an existing unique_identifier' do
    Member.create! :first_name => 'John', :last_name => 'Stewart', :unique_identifier => '973'
    capture_stderr { MembersFromCSV.populate good_file }
    Member.all.map(&:unique_identifier).should == %w[973 833]
  end
  
  context 'when unique_identifier is missing' do
    it 'makes up a unique_identifier' do
      capture_stderr { MembersFromCSV.populate bad_file }
      identifiers = Member.all.map(&:unique_identifier)
      identifiers.size.should == 4
      identifiers[0].should == '973'
      identifiers[1].should == '1'
      identifiers[2].should == '2'
      identifiers[3].should == '833'
    end
  
    it 'informs the user' do
      stderr = capture_stderr { MembersFromCSV.populate bad_file }
      stderr.should =~ /Hannity/
      stderr.should =~ /Maddow/
      stderr.should_not =~ /Stewart/
      stderr.should_not =~ /Kelly/
    end
    
    context 'and script is run twice' do
      it 'does not put the missing user in twice' do
        capture_stderr { MembersFromCSV.populate bad_file }
        capture_stderr { MembersFromCSV.populate bad_file }
        Member.count.should == 4
      end
    end
  end
  
end
