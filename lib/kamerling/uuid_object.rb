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

      def == other
        uuid == other.uuid
      end

      define_method :to_h do
        {}.tap do |hash|
          attrs.keys.map do |attr|
            case value = instance_variable_get("@#{attr}")
            when Addr    then hash[:host], hash[:port] = value.host, value.port
            when Client  then hash[:client_uuid]  = client.uuid
            when Project then hash[:project_uuid] = project.uuid
            when Task    then hash[:task_uuid]    = task.uuid
            else hash[attr] = value
            end
          end
        end
      end
    end
  end
end
