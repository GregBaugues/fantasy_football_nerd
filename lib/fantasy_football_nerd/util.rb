class Hash

  def add_snakecase_keys
    new_hash = {}
    self.each do |k,v|
      v.add_snakecase_keys if v.is_a? Hash
      new_hash[k.snakecase] = v
    end
    self.merge!(new_hash)
  end

  def change_key(source, target)
    unless self[source].nil?
      self[target] = self[source]
      self.delete(source)
    end
  end

  def change_keys_to_ints
    keys = self.keys
    keys.each do |k|
      self[k].change_keys_to_ints if self[k].is_a? Hash
      self.change_key(k, k.to_i) unless k.match(/[a-z]/)
    end
    self
  end

  def change_keys(key_hash)
    key_hash.each { |k,v| self.change_key(k,v) }
  end

  def change_string_values_to_floats
    self.each do |k,v|
      self[k] = ((float = Float(v)) && (float % 1.0 == 0) ? float.to_i : float) rescue v
    end
  end

end

class String
  def snakecase
    self.gsub(/::/, '/').
    gsub(/TD/, 'Td').
    gsub(/PA/, 'Pa').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end