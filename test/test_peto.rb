require 'helper'

class Closed
end

class TestPeto < Test::Unit::TestCase
  context "Master instance" do
    setup do
      @peto = Peto::Master.new
    end

    context "loads contract yaml file" do
      setup do
        @peto.load("test/contracts/loading.yml")
      end
      context ".contract" do
        should "return loaded contract" do
          assert_equal({ "name" => "loading" }, @peto.contract)
        end
      end
    end

    context "parse procedures" do
      setup do
        @peto.load("test/contracts/generating.yml")
      end
      should "returns string by loaded contract" do
        assert_equal Hash, @peto.parse.class
        @peto.parse.each do |name, content|
          assert_equal String, name.class
          assert_equal String, content.class
        end
      end
    end
  end

  context "Generated ruby script" do
    setup do
      @peto = Peto::Master.new
      @peto.load("test/contracts/generating.yml")
      @generated = @peto.parse
    end
    should "be readable as ruby" do
      @generated.each do |filepath, content|
        Closed.class_eval(content)
      end
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
