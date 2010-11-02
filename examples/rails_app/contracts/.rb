require "peto/mixin/peto_errorable"

module Peto
  class Foo
    extend PetoErrorable
    def self.set_user(user)
      invalid_type("user", User, user) unless user.class == User
      raise_errors unless errors.empty?

      return {
        :procedure => "set_user",
        :args => {
          :user => hashize(user),
        }
      }
    end


    def self.hashize(var)
      return var if [Fixnum, String].include?(var.class)
      var.to_hash
    end
  end
end
