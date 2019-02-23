def source_paths
  [File.join(__dir__, 'files')]
end

copy_file 'Brewfile'

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

gem 'bugsnag'

gem 'puma'

gem 'dotenv-rails'
copy_file '.env.example'
run 'cp .env.example .env'

copy_file 'docker-compose.yml'
template 'config/database.yml.erb', 'config/database.yml'

%w(bootstrap console serve setup test update).each do |script_name|
  copy_file "script/#{script_name}"
  run "chmod +x script/#{script_name}"
end

after_bundle do
  generate :controller, "home index --no-view-specs --no-helper-specs --skip-routes --no-helper --test-framework=rspec"
  route "root to: 'home#index'"
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

template 'README.md.erb', 'README.md'
copy_file 'docs/README.md'

template '.rubocop.yml.erb', '.rubocop.yml'
after_bundle do
  run 'bundle exec rubocop --auto-correct'
end
