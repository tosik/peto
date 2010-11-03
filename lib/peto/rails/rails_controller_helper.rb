
require "active_support/inflector"
require "pp"

module Peto
  module RailsControllerHelper
    def contract
      self.class.to_s.sub("Controller", "")
    end

    def peto_class
      "Peto::#{contract.to_s.camelize}".constantize
    end

    def parse_caller(at)
      if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
        {:file => $1, :line => $2.to_i, :method => $3.to_sym}
      end
    end


    # respond

    def procedure_name
      parse_caller(caller[(0..caller.length).zip(caller).find {|index,at|
        parse_caller(at)[:method] == :call_subaction
      }.first - 1])[:method]
    end

    def call_procedure_response(response_type, *args)
      peto_class.send(:"#{procedure_name}_#{response_type}", *args)
    end

    def respond(*args)
      render(:json => call_procedure_response(:response, *args).to_json)
    end

    def error(error_name, *messages)
      render(:json => call_procedure_response(:"error_#{error_name}", messages.join(",")))
    end


    # subaction

    def index
      call_subaction(params[:procedure], params[:args])
    end

    def valid_args?(procedure, args)
      peto_class.send(:"#{procedure}_valid?", args)
    end

    def hash_to_args(procedure, hash_args)
      peto_class.send(:"#{procedure}_hash_to_args", hash_args)
    end

    def call_subaction(procedure, hash_args)
      args = hash_to_args(procedure, hash_args)
      valid_args?(procedure, *args) # raise error
      send(procedure, *args)
    end
  end
end
