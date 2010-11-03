require "peto"
require "rake"
require "rake/tasklib"

module Peto
  class RakeTask < ::Rake::TaskLib
    attr_accessor :contracts
    attr_accessor :output_dir
    attr_accessor :name
    attr_accessor :fail_on_error
    attr_accessor :failure_message

    def initialize(*args)
      @contracts ||= []
      @output_dir ||= "./"
      @name ||= :peto
      @fail_on_error ||= true

      yield self if block_given?

      desc("Generate codes by contracts") unless ::Rake.application.last_comment

      task name do
        RakeFileUtils.send(:verbose, verbose) do
          if contracts.empty?
            puts "No contracts"
          else
            begin
              self.contracts = [contracts] if contracts.class == String
              contracts.each do |contract|
                peto = Peto::Master.new
                peto.load(contract)
                peto.generate(output_dir)
              end
            rescue
              puts failure_message if failure_message
              raise "peto failed" if fail_on_error
            end
          end
        end
      end
    end
  end
end

