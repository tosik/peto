require "foo"
require "user"
require "animal"

class FooController < ApplicationController
  def set_user(args)
    respond(123, "foo bar baz")
    #error(:invalid_user, "aho #{args}")
  end
end
