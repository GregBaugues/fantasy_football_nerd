class Hash

  def add_snakecase_keys
    new_hash = {}
    self.each do |k,v|
      v.add_snakecase_keys if v.is_a? Hash
      new_hash[k.snakecase] = v
    end
    self.merge!(new_hash)
  end

end

class String
  def snakecase
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end