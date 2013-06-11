module Kamerling
  def self.UUIDObject *params
    class_definition_from attrs_from params
  end

  private

  def self.attrs_from params
    { uuid: -> { UUID.new } }.tap do |attrs|
      attrs.merge! params.pop if params.last.is_a? Hash
      params.each { |par| attrs[par] = -> { raise "param #{par} is required" } }
    end
  end

  def self.class_definition_from attrs
    Class.new do
      define_singleton_method :from_h do |hash, repos = Repos|
        args = Hash[hash.map do |key, value|
          case key
          when :host, :port  then [:addr,    Addr[hash[:host], hash[:port]]]
          when :client_uuid  then [:client,  repos[Client][value]]
          when :project_uuid then [:project, repos[Project][value]]
          when :task_uuid    then [:task,    repos[Task][value]]
          else [key, value]
          end
        end]
        new args
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

      define_method :== do |other|
        uuid == other.uuid
      end

      define_method :to_h do
        {}.tap do |hash|
          attrs.keys.map do |attr|
            case value = instance_variable_get("@#{attr}")
            when Addr    then hash[:host], hash[:port] = value.host, value.port
            when Client  then hash[:client_uuid]       = client.uuid
            when Project then hash[:project_uuid]      = project.uuid
            when Task    then hash[:task_uuid]         = task.uuid
            else              hash[attr]               = value
            end
          end
        end
      end
    end
  end
end
