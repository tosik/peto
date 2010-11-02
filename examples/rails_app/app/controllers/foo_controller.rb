require "foo"
require "user"
require "animal"

class FooController < ApplicationController
  def set_user(args)
    respond(123, "foo bar baz")
  end
end
