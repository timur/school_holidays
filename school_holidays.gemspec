$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "school_holidays/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "school_holidays"
  s.version     = SchoolHolidays::VERSION
  s.authors     = ["Timur Yalcin"]
  s.email       = ["timur.yalcin@web.de"]
  s.homepage    = "www.ruby-rails-net"
  s.summary     = "A gem for handling with school holidays."
  s.description = "TODO: Description of SchoolHolidays."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files  = Dir.glob("{spec,test}/**/*.rb")

  s.add_dependency "rails", "~> 3.2.8"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec', '~> 2.5'  
end
