def add_file name
  file name, File.read(File.join(__dir__, 'files', name))  
end

def source_paths
  [File.join(__dir__, 'files')]
end

add_file 'Brewfile'

gem_group :development, :test do
  # help identify and catch n+1 queries
  # gem 'bullet'

  gem 'factory_bot_rails'
  gem 'faker'

  gem 'rubocop', '~> 0.64.0', require: false
  gem 'rubocop-rspec', require: false
end

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.8'
end

after_bundle do
  run "spring stop"
  generate 'rspec:install'
end

gem 'devise'

after_bundle do
  generate 'devise:install'

  environment(
    'config.action_mailer.default_url_options = {host: "localhost", port: 3000}',
    env: 'development'
  )

  generate :devise, "User"
end

gem 'bugsnag'

gem 'puma'

gem 'dotenv-rails'
add_file '.env.example'
run 'cp .env.example .env'

add_file 'docker-compose.yml'
template 'config/database.yml.erb', 'config/database.yml'

%w(bootstrap console serve setup test update).each do |script_name|
  add_file "script/#{script_name}"
  run "chmod +x script/#{script_name}"
end

template 'README.md.erb', 'README.md'
add_file 'docs/README.md'

template '.rubocop.yml.erb', '.rubocop.yml'
after_bundle do
  run 'bundle exec rubocop --auto-correct'
end
