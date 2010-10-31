require 'helper'

class Closed
end

class TestPeto < Test::Unit::TestCase
  context "Master instance" do
    setup do
      @peto = Peto::Master.new
    end

    context "load contract yaml file" do
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

  context "Generated ruby script" do
    setup do
      @peto = Peto::Master.new
      @peto.load("test/contracts/generating.yml")
      @generated = @peto.generate
    end
    should "is readable as ruby" do
      Closed.class_eval(@generated)
      assert_equal({
        :procedure => "do_a",
        :args => {
          :a => 1,
          :b => "two",
          :c => {:foo=>"foo"},
        }
      }, Closed::Peto::Generating.do_a(1, "two", Closed::Peto::TypeB.new(:foo=>"foo")))
    end
  end
end
