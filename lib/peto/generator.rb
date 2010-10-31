
require "erb"
require "active_support/inflector"

class String
  def to_method_name
    underscore.split(" ").join("_")
  end
end

module Peto
  class Generator
    def initialize(contract)
      @contract = contract
    end

    def generate(template_filename)
      erb = ERB.new(IO.read(template_filename), nil, "-")
      erb.result(binding)
    end


    def class_name
      @contract["name"].camelize
    end

    def each_procedures
      @contract["procedures"].each do |procedure|
        yield procedure.to_method_name, @contract[procedure]["args"]
        @contract[procedure]["errors"].each do |error|
          yield "#{procedure} error #{error}".to_method_name, ["message"]
        end
      end
    end
  end
end
