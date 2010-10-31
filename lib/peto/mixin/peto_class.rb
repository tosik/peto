
module PetoClass
  def set_by_hash(hash)
    hash.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
end

