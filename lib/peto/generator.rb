
require "erb"
require "active_support/inflector"

class String
  def to_method_name
    underscore.split(" ").join("_")
  end
  def to_class_type
    case self
    when "s32"
      "Fixnum"
    else
      classify
    end
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

    def args(string_args)
      string_args.map do |str|
        splitted = str.split(":")
        { :name => splitted.first, :type => splitted.last.to_class_type}
      end
    end

    def each_procedures
      @contract["procedures"].each do |procedure|
        yield procedure.to_method_name, args(@contract[procedure]["args"])
        @contract[procedure]["errors"].each do |error|
          yield "#{procedure} error #{error}".to_method_name, [{ :name => "message", :type => "string".to_class_type }]
        end
      end
    end
  end
end
