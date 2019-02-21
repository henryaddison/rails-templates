def add_file name
  file name, File.read(File.join(__dir__, 'files', name))  
end

def add_template name, vars={}
  template = ERB.new(File.read(File.join(__dir__, 'templates', "#{name}.erb")))
  file name, template.result_with_hash(vars)
end

add_file 'Brewfile'
run 'brew bundle'

add_template '.ruby-version', ruby_version: '2.6.1'

run 'rbenv install'

gem_group :development, :test do
  # help identify and catch n+1 queries
  gem 'bullet'

  gem 'factory_bot_rails'
  gem 'faker'

  # enforce code style
  gem 'rubocop', '~> 0.64.0', require: false
  gem 'rubocop-rspec', require: false
end

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.8'
end

after_bundle do
  run "spring stop"
  generate 'rspec:install'
  run "rm -rf test"
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

add_template 'README.md', app_name: app_name
add_file 'docs/README.md'

add_file '.env.example'
run 'cp .env.example .env'

%w(bootstrap console serve setup test update).each do |script_name|
  add_file "script/#{script_name}"
  run "chmod +x script/#{script_name}"
end

add_file 'docker-compose.yml'
add_template 'config/database.yml', app_name: app_name

add_template '.rubocop.yml', ruby_version: '2.5'
after_bundle do
  run 'bundle exec rubocop'
end
