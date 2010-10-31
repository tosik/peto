
require "erb"
require "active_support/inflector"

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
        yield procedure, @contract[procedure]
      end
    end
  end
end
