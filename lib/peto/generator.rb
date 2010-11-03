
require "erb"
require "active_support/inflector"
require "active_support/core_ext/array/access"
require "pp"

class String
  def to_method_name
    underscore.split(" ").join("_")
  end
  def to_rb_class_type
    case self
    when "integer"
      "Fixnum"
    else
      classify
    end
  end
  def to_as_class_type
    case self
    when "integer"
      "int"
    when "Number"
      "int"
    when "Boolean"
      "Boolean"
    when "string"
      "String"
    when "array"
      "Array"
    else
      self.capitalize
    end
  end
  def to_class_type(language)
    send(:"to_#{language}_class_type")
  end
end

def rb_primitive_types
  [Fixnum, String]
end
def as_primitive_types
  ["int", "String", "Number", "uint", "Boolean"]
end
def as_default_value(type)
  case type
  when "int"
    "0"
  else
    "null"
  end
end

module Peto
  class Generator
    def initialize(contract, language)
      @contract = contract
      @language = language
    end
    attr_reader :contract

    def generate_procedure(template_filename)
      erb = ERB.new(IO.read(template_filename), nil, "-")
      { "#{@contract["name"]}" => erb.result(binding) }
    end

    def generate_class(template_filename, type)
      erb = ERB.new(IO.read(template_filename), nil, "-")
      @target = {:name => type.first, :args => args(type.second)}
      { "#{@target[:name]}" => erb.result(binding) }
    end

    def class_name
      @contract["name"].to_class_type(@language)
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
        :type => type.to_class_type(@language),
        :array_type => array_type.nil? ? nil : array_type.to_class_type(@language),
      }
    end

    def each_types
      @contract["types"].each do |name, args|
        yield name.to_class_type(@language), args(args)
      end
    end

    def each_procedures
      (@contract["procedures"]||[]).each do |name, procedure|
        yield name.to_method_name, args(procedure["args"])
        yield "#{name} response".to_method_name, args(procedure["returns"])
        (procedure["errors"]||[]).each do |error|
          yield "#{name} error #{error}".to_method_name, [arg("message", "string")]
        end
      end
    end
  end
end
