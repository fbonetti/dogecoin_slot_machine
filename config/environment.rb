# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Get secrets
SECRETS = YAML.load_file("#{Rails.root}/config/secrets.yml")

# Initialize the Rails application.
SlotMachineApp::Application.initialize!