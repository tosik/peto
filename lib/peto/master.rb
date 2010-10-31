require "pathname"
require "yaml"
require "peto/generator"

module Peto
  TEMPLATE_DIR = File::dirname(File::expand_path( __FILE__ )) + "/../templates"
  class Master
    def load(filename)
      @filename = filename
      @contract = YAML.load(IO.read(Pathname(filename)))
    end
    attr_reader :contract

    def parse
      (@contract["types"]||{}).inject({}) {|result, type|
        result.merge!(Generator.new(@contract).generate_class(TEMPLATE_DIR + "/rb_classes.erb", type))
      }.merge!(Generator.new(@contract).generate_procedure(TEMPLATE_DIR + "/rb_procedures.erb"))
    end

    def generate(output_dir=nil)
      parse.each do |name, content|
        filepath = File.join(output_dir||File::dirname(@filename), "#{name}.rb")
        write(filepath, content)
      end
    end

    def write(filepath, content)
      print "  "
      if File.exist?(filepath)
        if File.read(filepath) == content
          print "identical"
        else
          print "update   "
        end
      else
        print "create   "
      end
      print "  "

      open(filepath, "w") do |file|
        file.write(content)
      end

      puts filepath
    end
  end
end

