module Kamerling
  def self.UUIDObject *params
    class_definition_from attrs_from params
  end

  private

  def self.attrs_from params
    { uuid: -> { UUID.new } }.tap do |attrs|
      attrs.merge! params.pop if params.last.is_a? Hash
      params.each { |p| attrs[p] = -> { raise "param #{p} is required" } }
    end
  end

  def self.class_definition_from attrs
    Class.new do
      define_singleton_method(:attrs) { attrs }

      def self.from_h hash, repos = Repos
        args = Hash[hash.map do |key, value|
          from_h_mapping hash, key, repos
        end]
        new args
      end

      def initialize args = {}
        attrs   = self.class.attrs
        @values = Hash[attrs.map do |attr, default|
          value = args.fetch attr do
            default.respond_to?(:call) ? default.call : default
          end
          [attr, value]
        end]
      end

      def == other
        uuid == other.uuid
      end

      attrs.keys.each do |attr|
        define_method(attr)       { @values[attr]             }
        define_method("#{attr}=") { |val| @values[attr] = val }
      end

      def to_h
        {}.tap do |hash|
          self.class.attrs.keys.map do |attr|
            hash.merge! to_h_mapping attr
          end
        end
      end

      private

      def self.from_h_mapping hash, key, repos
        case key
        when :host, :port, :prot
          [:addr, Addr[hash[:host], hash[:port], hash[:prot].to_sym]]
        when :client_uuid  then [:client,  repos[Client][hash[key]]]
        when :project_uuid then [:project, repos[Project][hash[key]]]
        when :task_uuid    then [:task,    repos[Task][hash[key]]]
        else [key, hash[key]]
        end
      end

      def to_h_mapping attr
        case value = @values[attr]
        when Addr
          { host: value.host, port: value.port, prot: value.prot.to_s }
        when Client  then { client_uuid:  client.uuid  }
        when Project then { project_uuid: project.uuid }
        when Task    then { task_uuid:    task.uuid    }
        else { attr => value }
        end
      end
    end
  end
end
