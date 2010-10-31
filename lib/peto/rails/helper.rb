
require "active_support/inflector"

module Peto
  module RailsHelper
    def contract
      :procedures
    end

    def call_procedure_response(procedure_name, *args)
      "Peto::#{contract.to_s.camelize}".constantize.send("#{procedure_name}", args.join(","))
    end

    def respond(*args)
      call_procedure_response(:response, *args)
    end

    def error(error_name, *messages)
      call_procedure_response("error_#{error_name}", messages.join(","))
    end
  end
end
