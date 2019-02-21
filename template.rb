def add_file name
  file name, File.read(File.join(__dir__, 'files', name))  
end

def add_template name, vars={}
  template = ERB.new(File.read(File.join(__dir__, 'templates', "#{name}.erb")))
  file name, template.result_with_hash(vars)
end

add_file 'Brewfile'
run 'brew bundle'

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

  rails_command "db:migrate"
end

add_file 'README.md'
add_file 'docker-compose.yml'
add_template 'config/database.yml', app_name: app_name
