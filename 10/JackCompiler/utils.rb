module Utils
  def is_number?(string)
    Float(string) != nil rescue false
  end
end