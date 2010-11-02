$: << "../lib"
$: << "../works"
require "peto/rails/rails_controller_helper"

class ApplicationController < ActionController::Base
  include Peto::RailsControllerHelper

  protect_from_forgery
end
