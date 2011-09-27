module MembersFromCSV
  extend self
  
  def populate(file)
    require 'csv'
    CSV.new(file).drop(1).each do |last_name, first_name, unique_identifier|
      add_member_from_csv first_name, last_name, unique_identifier
    end
  end

private
  
  def add_member_from_csv(first_name, last_name, unique_identifier)
    if unique_identifier.nil?
      return if db_already_has_someone_named? first_name, last_name
      unique_identifier = mock_unique_identifier
      warn_that_we_mocked_unique_identifier_for first_name, last_name, unique_identifier
    end
    Member.create :first_name => first_name, :last_name => last_name, :unique_identifier => unique_identifier
  end

  def warn_that_we_mocked_unique_identifier_for(first_name, last_name, unique_identifier)
    $stderr.puts "#{first_name}, #{last_name} has been assigned the identifier #{unique_identifier} as theirs is missing from the CSV file.\n"
  end
  
  def db_already_has_someone_named?(first_name, last_name)
    Member.where(:first_name => first_name, :last_name => last_name).first
  end
  
  def mock_unique_identifier
    (1..Float::INFINITY).find do |potential_identifier| 
      !Member.find_by_unique_identifier(potential_identifier)
    end
  end
  
end
