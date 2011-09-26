Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-simple_members'
  s.version           = '0.1.0'
  s.description       = 'Ruby on Rails Members engine for Refinery CMS'
  s.date              = '2011-09-19'
  s.summary           = 'Simple list of members that have first/last name, email, and a unique identifier.'
  s.require_paths     = %w(lib)
  s.files             = Dir['lib/**/*', 'config/**/*', 'app/**/*']
end
