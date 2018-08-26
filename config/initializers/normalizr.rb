Normalizr.configure do
  add :without_strange_chars do |value|
    if value.is_a? String
      value.tr('.,-', '')
    end
  end
end
