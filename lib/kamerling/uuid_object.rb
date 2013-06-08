module Kamerling
  def self.UUIDObject *attrs
    attrs << :uuid

    Class.new do
      class << self
        alias [] new
      end

      define_singleton_method :from_h do |hash|
        new hash
      end

      attr_reader(*attrs)

      define_method :initialize do |args|
        args[:uuid] ||= UUID.new
        attrs.each { |attr| instance_variable_set "@#{attr}", args[attr] }
      end

      def == other
        uuid == other.uuid
      end

      define_method :to_h do
        Hash[attrs.map { |attr| [attr, instance_variable_get("@#{attr}")] }]
      end
    end
  end
end
