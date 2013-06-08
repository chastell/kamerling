module Kamerling
  def self.UUIDObject *params
    attrs = params.last.is_a?(Hash) ? params.pop : {}
    params.each do |param|
      attrs[param] = -> { raise "param #{param} is required" }
    end
    attrs[:uuid] ||= -> { UUID.new }

    Class.new do
      class << self
        alias [] new
      end

      define_singleton_method :from_h do |hash|
        new hash
      end

      attr_accessor(*attrs.keys)

      define_method :initialize do |args = {}|
        attrs.keys.each do |attr|
          value = args.fetch attr do
            attrs[attr].is_a?(Proc) ? attrs[attr].call : attrs[attr]
          end
          instance_variable_set "@#{attr}", value
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
