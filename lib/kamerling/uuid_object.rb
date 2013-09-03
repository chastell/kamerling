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
          case key
          when :host, :port, :prot
            [:addr, Addr[hash[:host], hash[:port], hash[:prot].to_sym]]
          when :client_uuid  then [:client,  repos[Client][value]]
          when :project_uuid then [:project, repos[Project][value]]
          when :task_uuid    then [:task,    repos[Task][value]]
          else [key, value]
          end
        end]
        new args
      end

      def initialize args = {}
        attrs   = self.class.attrs
        @values = Hash[attrs.keys.map do |attr|
          value = args.fetch attr do
            attrs[attr].is_a?(Proc) ? attrs[attr].call : attrs[attr]
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
            case value = @values[attr]
            when Addr
              hash.merge! host: value.host, port: value.port,
                prot: value.prot.to_s
            when Client  then hash[:client_uuid]  = client.uuid
            when Project then hash[:project_uuid] = project.uuid
            when Task    then hash[:task_uuid]    = task.uuid
            else              hash[attr]          = value
            end
          end
        end
      end
    end
  end
end
