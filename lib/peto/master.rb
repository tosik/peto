require "pathname"
require "yaml"
require "peto/generator"

module Peto
  TEMPLATE_DIR = File::dirname( File::expand_path( __FILE__ ) ) + "/../templates"
  class Master
    def load(filename)
      @contract = YAML.load(IO.read(Pathname(filename)))
    end
    attr_reader :contract

    def generate
      Generator.new(@contract).generate(TEMPLATE_DIR + "/rb_procedures.erb")
    end
  end
end

