# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
SlotMachineApp::Application.initialize!

SECRETS = YAML.load_file("#{Rails.root}/config/secrets.yml")