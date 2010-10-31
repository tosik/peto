module PetoErrorable
  def errors
    @errors ||= []
  end

  def add_error(error)
    errors << error
  end

  def raise_errors
    raise errors.join("\n")
  end

  def invalid_type(name, expect, real)
    add_error(["invalid type : #{name}.class is expected #{expect}, but was #{real.class}"])
  end
end
