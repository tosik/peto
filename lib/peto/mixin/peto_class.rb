require "peto/mixin/peto_errorable"

module PetoClass
  include PetoErrorable

  def set_by_hash(hash)
    hash.each do |key, value|
      var = instance_variable_get("@#{key}")
      invalid_type(key, types[key], value) unless value.class == types[key] || value.nil?
      raise_errors unless errors.empty?
      instance_variable_set("@#{key}", value)
    end
  end

  def inspect
    inners = members.inject({}) {|result, member|
      result[member] = instance_variable_get("@#{member}")
      result
    }
    "#{self.class}(#{inners})"
  end
end

