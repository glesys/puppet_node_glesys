source 'https://rubygems.org'

group :development do
  gem 'rake'
end

gem 'fog', '>= 1.29.0', :require => false

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
