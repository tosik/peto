require 'helper'
require "pp"

class TestPeto < Test::Unit::TestCase
  context "Master instance" do
    setup do
      @peto = Peto::Master.new
    end

    context "load(contract yaml file)" do
      setup do
        @peto.load("test/contracts/loading_test.yml")
      end
      should ".contract returns loaded contract" do
        assert_equal({ "name" => "loading_test" }, @peto.contract)
      end
    end

    context "generate procedures" do
      setup do
        @peto.load("test/contracts/procedures.yml")
      end
      should "returns string by loaded contract" do
        puts @peto.generate
        assert_equal String, @peto.generate.class
      end
    end
  end
end
