
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
      @contract["name"].to_class_type
    end

    def args(string_args)
      string_args.map do |str|
        splitted = str.split(":")
        arg(splitted.first, splitted.last, :array => (splitted[1] == "array"))
      end
    end

    def arg(name, type, options={})
        {
          :name => name,
          :type => type.to_class_type,
          :array => options.delete(:array) || false,
        }
    end

    def each_types
      @contract["types"].each do |type|
        yield type.to_class_type, args(@contract[type])
      end
    end

    def each_procedures
      @contract["procedures"].each do |procedure|
        yield procedure.to_method_name, args(@contract[procedure]["args"])
        @contract[procedure]["errors"].each do |error|
          yield "#{procedure} error #{error}".to_method_name, [arg("message", "string")]
        end
      end
    end
  end
end
