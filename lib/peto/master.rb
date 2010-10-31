
require "pathname"
require "yaml"
require "peto/generator"

module Peto
  class Master
    def load(filename)
      @contract = YAML.load(IO.read(Pathname(filename)))
    end
    attr_reader :contract

    def generate
      Generator.new(@contract).generate("lib/templates/rb_procedures.erb")
    end
  end
end

