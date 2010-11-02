require 'test_helper'

class FooControllerTest < ActionController::TestCase
  test "set_user" do
    peto_post("set_user", Peto::User.new(:name=>"aho"))
    assert_response :success
    assert_peto_response("a"=>123, "b"=>"foo bar baz")
  end
end
