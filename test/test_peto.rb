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
        assert_equal({
          "name" => "loading_test",
          "procedures" => ["do_a", "do_b", "do_c"],
          "do_a" => {"args" => ["a","b","c"]},
          "do_b" => {"args" => ["a"]},
          "do_c" => {"args" => []},
        }, @peto.contract)
      end
    end

    context "generate" do
      setup do
        @peto.load("test/contracts/loading_test.yml")
      end
      should "returns string by loaded contract" do
        puts @peto.generate
        assert_equal String, @peto.generate.class
      end
    end
  end
end
