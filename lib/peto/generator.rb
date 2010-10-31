
require "erb"
require "active_support/inflector"
require "active_support/core_ext/array/access"
require "pp"

class String
  def to_method_name
    underscore.split(" ").join("_")
  end
  def to_class_type
    case self
    when "integer"
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
        arg(splitted.first, splitted.second, :array_type => splitted.third)
      end
    end

    def arg(name, type, options={})
      array_type = options.delete(:array_type)
      {
        :name => name,
        :type => type.to_class_type,
        :array_type => array_type.nil? ? nil : array_type.to_class_type,
      }
    end

    def each_types
      @contract["types"].each do |name, args|
        yield name.to_class_type, args(args)
      end
    end

    def each_procedures
      @contract["procedures"].each do |name, procedure|
        yield name.to_method_name, args(procedure["args"])
        (procedure["errors"]||[]).each do |error|
          yield "#{name} error #{error}".to_method_name, [arg("message", "string")]
        end
      end
    end
  end
end
