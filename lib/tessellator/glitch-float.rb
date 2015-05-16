class Float
  def self.randomize_methods(options)
    randomize_method(:+, options, options[:add_variance] || options[:addsub_variance] || options[:variance])
    randomize_method(:-, options, options[:sub_variance] || options[:addsub_variance] || options[:variance])
  end

private
  def self.randomize_method(method_name, options, _variance=options[:variance])
    puts "Float##{method_name} = n #{method_name} other ± #{_variance}"

    original_method_name = "original_#{method_name.to_s}".to_sym

    alias_method original_method_name, method_name

    define_method(method_name) do |other|
      variance = _variance
      variance = options[:variance] if variance == 'variance'
      variance = other if variance == 'other'

      return send(original_method_name, other) if variance == 0

      offset = rand.send(original_method_name, rand(variance))
      offset = rand(2) ? offset : -offset

      send(original_method_name, other).send(original_method_name, offset)
    end
  end
end
