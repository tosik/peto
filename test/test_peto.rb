require 'helper'
require "pp"

class TestPeto < Test::Unit::TestCase
  context "Master instance" do
    setup do
      @peto = Peto::Master.new
    end

    context "load(contract yaml file)" do
      setup do
        @peto.load("test/contracts/loading.yml")
      end
      should ".contract returns loaded contract" do
        assert_equal({ "name" => "loading" }, @peto.contract)
      end
    end

    context "generate procedures" do
      setup do
        @peto.load("test/contracts/generating.yml")
      end
      should "returns string by loaded contract" do
        assert_equal String, @peto.generate.class
      end
    end
  end
end
