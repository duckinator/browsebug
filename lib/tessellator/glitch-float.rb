class Float
  def self.randomize_method(method_name, _variance=$VARIANCE)
    puts "Float##{method_name} = n + other ± #{_variance}"

    original_method_name = "original_#{method_name.to_s}".to_sym

    alias_method original_method_name, method_name

    define_method(method_name) do |other|
      variance = _variance
      variance = $OPTIONS[:variance] if variance == 'variance'
      variance = other      if variance == 'other'

      return send(original_method_name, other) if variance == 0

      offset = rand.send(original_method_name, rand(variance))
      offset = rand(2) ? offset : -offset

      send(original_method_name, other).send(original_method_name, offset)
    end
  end

  randomize_method(:+, $OPTIONS[:add_variance] || $OPTIONS[:addsub_variance] || $OPTIONS[:variance])
  randomize_method(:-, $OPTIONS[:sub_variance] || $OPTIONS[:addsub_variance] || $OPTIONS[:variance])
end
