require "pathname"
require "yaml"
require "fileutils"
require "term/ansicolor"
require "peto/generator"

class String
  include Term::ANSIColor
end

module Peto
  TEMPLATE_DIR = File::dirname(File::expand_path( __FILE__ )) + "/../templates"
  class Master
    def load(filename)
      @filename = filename
      @contract = YAML.load(IO.read(Pathname(filename)))
    end
    attr_reader :contract

    def parse(language)
      (@contract["types"]||{}).inject({}) {|result, type|
        result.merge!(Generator.new(@contract, language).generate_class(TEMPLATE_DIR + "/#{language}_classes.erb", type))
      }.merge!(Generator.new(@contract, language).generate_procedure(TEMPLATE_DIR + "/#{language}_procedures.erb"))
    end

    def class_filename(name, language)
      case language
      when "rb"
        "#{name}.#{language}"
      when "as"
        "peto/#{name.capitalize}.#{language}"
      else
        raise "invalid language #{language.inspect}"
      end
    end

    def generate(language, output_dir=nil)
      raise "language is nil" if language.nil?
      parse(language).each do |name, content|
        filepath = File.join(output_dir||File::dirname(@filename), language, class_filename(name, language))
        write(filepath, content)
      end
    end

    def write(filepath, content)
      print "  "
      if File.exist?(filepath)
        if File.read(filepath) == content
          print "identical".blue.bold
        else
          print "   update".white.bold
        end
      else
        FileUtils.mkdir_p(File.dirname(filepath))
        print "   create".green.bold
      end
      print " "

      open(filepath, "w") do |file|
        file.write(content)
      end

      puts filepath
    end
  end
end

