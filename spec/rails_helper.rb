# Load the Rails environment
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

# Load support files
Rails.root.glob('spec/support/**/*.rb').each { |f| require f }

RSpec.configure do |config|
  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!

  config.infer_spec_type_from_file_location!
end
