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
    "#{self.class}(#{to_hash})"
  end

  def to_hash
    inners = members.inject({}) {|result, member|
      result[member] = instance_variable_get("@#{member}")
      result
    }
  end

  def valid?
    to_hash.each do |key, value|
      var = instance_variable_get("@#{key}")
      invalid_type(key, types[key], value) unless value.class == types[key] || value.nil?
    end

    arrays.each do |array, klass|
      var = instance_variable_get("@#{array}")
      invalid_type(array, klass, var.first) unless var.empty? || var.first.class == klass
    end

    errors.empty?
  end
end

