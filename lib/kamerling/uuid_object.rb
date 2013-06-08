module Kamerling
  def self.UUIDObject attrs
    attrs[:uuid] = -> { UUID.new }

    Class.new do
      class << self
        alias [] new
      end

      define_singleton_method :from_h do |hash|
        new hash
      end

      attr_reader(*attrs.keys)

      define_method :initialize do |args = {}|
        attrs.keys.each do |attr|
          instance_variable_set "@#{attr}", args[attr] || attrs[attr].call
        end
      end

      def == other
        uuid == other.uuid
      end

      define_method :to_h do
        Hash[attrs.keys.map do |attr|
          [attr, instance_variable_get("@#{attr}")]
        end]
      end
    end
  end
end
