# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RailsApp::Application.initialize!

#ActionController::Base.param_parsers[Mime::Type::lookup("application/json")] = Proc.new {
#  ActiveSupport::JSON.decode(data)
#}
