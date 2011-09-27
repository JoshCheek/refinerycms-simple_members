namespace :refinery do
  namespace :simple_members do
    
    desc 'Populate the database from a CSV file where each line is a member of the format "last_name,first_name,unique_id"'
    task :populate_from_csv => :environment do
      require 'member'
      require 'members_from_csv'
      csv_name = ENV['csv']
      unless csv_name && File.exists?(csv_name)
        raise "Invoke like `$ rake refinery:simple_members:populate_from_csv csv=BlueMaxRoster.csv`\nNOTE: should be relative to dir of Rakefile"
      end
      File.open csv_name, &MembersFromCSV.method(:populate)
    end
  end  
end
