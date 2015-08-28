# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'shoulda/matchers'
require 'capybara/rails'
require 'database_cleaner'
require 'aws-sdk'
require 'vcr'


$original_sunspot_session = Sunspot.session

RSpec.configure do |config|
  config.before do
    Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
  end

  config.before :each, :solr => true do
    Sunspot::Rails::Tester.start_original_sunspot_session
    Sunspot.session = $original_sunspot_session
    Sunspot.remove_all!
  end
end
# DEFAULT_HOST = "testhost.com"
# DEFAULT_PORT = 7171 

#Do not delay jobs for tests
Delayed::Worker.delay_jobs = false

module Paperclip
  def self.run cmd, arguments = "", interpolation_values = {}, local_options = {}
    cmd == 'convert' ? nil : super
  end
end

class Paperclip::Attachment
  def post_process
  end
end

#=> { :reservation_set => [...] } 
# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include ActionDispatch::TestProcess

  config.around(:each) do |example|
    VCR.use_cassette(example.metadata[:full_description]) do
      example.run
    end
  end

  config.include(Omniauth)

  config.around(:each, :delayed_job) do |example|
    old_value = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = true
    Delayed::Job.destroy_all

    example.run

    Delayed::Worker.delay_jobs = old_value
  end

  config.include Capybara::DSL
  Capybara.javascript_driver = :webkit

  # Capybara.default_host = "http://#{DEFAULT_HOST}"
  # Capybara.server_port = DEFAULT_PORT
  # Capybara.app_host = "http://#{DEFAULT_HOST}:#{Capybara.server_port}"

  #fixes issues with capybara not detecting db changes made during tests
  config.use_transactional_fixtures = false

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end  

  Capybara::Webkit.configure do |config|
    config.allow_url("testhost.com")
    config.allow_url("s3-us-west-2.amazonaws.com")
    config.allow_url("secure.gravatar.com")
    config.allow_url("raw.githubusercontent.com")
    config.allow_url("checkout.stripe.com")
    config.block_url("http://use.typekit.net")
  end

  OmniAuth.config.test_mode = true

  puts "rspec pid: #{Process.pid}"

  trap 'USR1' do
    threads = Thread.list

    puts
    puts "=" * 80
    puts "Received USR1 signal; printing all #{threads.count} thread backtraces."

    threads.each do |thr|
      description = thr == Thread.main ? "Main thread" : thr.inspect
      puts
      puts "#{description} backtrace: "
      puts thr.backtrace.join("\n")
    end

    puts "=" * 80
  end
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end
