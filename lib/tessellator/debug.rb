require 'spinny/utilities'

module Tessellator
  class << self
    attr_accessor :debug
  end

  module Debug
    def debug(*args)
      $stderr.puts(debuggify(*args)) if Tessellator.debug
    end

    def debug_print(*args)
      $stderr.print(debuggify(*args)) if Tessellator.debug
    end

    def debug_print_call
      return unless Tessellator.debug

      binding   = Spinny::Utilities.caller_binding
      _method   = Spinny::Utilities.caller_method
      receiver  = _method.receiver
      separator = nil

      # Hilariously unreliable check: _method.receiver.class is a Class or Module,
      # we assume it's a class method; otherwise, an instance method.
      if [Class, Module].include?(_method.receiver.class)
        separator = '.'
      else
        separator = '#'
        receiver = receiver.class
      end

      args =
        _method.parameters.map do |(type, name)|
          begin
            is_key = [:key, :keyreq].include?(type)

            ret = binding.eval(name.to_s).inspect
            ret = "#{name.inspect[1..-1]}: #{ret}" if is_key

            ret
          rescue
            nil
          end
        end.reject(&:nil?)

      $stderr.puts "[#{receiver}#{separator}#{_method.name}(#{args.join(', ')})]"
    end

    private
    def debuggify(*args)
      args.map {|x| "[DEBUG] " + x.to_s}
    end
  end
end
