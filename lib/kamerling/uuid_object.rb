module Kamerling class UUIDObject
  def self.new *params
    class_definition_from attrs_from params
  end

  class << self
    private

    def attrs_from params
      { uuid: -> { UUID.new } }.tap do |attrs|
        attrs.merge! params.pop if params.last.is_a? Hash
        attrs.merge! raises_from params
      end
    end

    def class_definition_from attrs
      new_class = Class.new
      new_class.class_eval do
        define_singleton_method(:attrs) { attrs }
        attrs.each do |attr, _|
          define_method(attr)       { @values[attr]             }
          define_method("#{attr}=") { |val| @values[attr] = val }
        end
      end
      define_from_h_on new_class
      define_initialize_on new_class
      define_eq_on new_class
      define_to_h_on new_class
      new_class
    end

    def define_from_h_on new_class
      new_class.class_eval do
        def self.from_h hash, repos: Repos
          args = hash.reduce({}) do |result, (key, _)|
            result.merge from_h_mapping hash, key, repos
          end
          new args
        end

        private

        def self.from_h_mapping hash, key, repos
          case key
          when :host, :port, :prot
            { addr: Addr[hash[:host], hash[:port], hash[:prot].to_sym] }
          when :client_uuid  then { client:  repos[Client][hash[key]]  }
          when :project_uuid then { project: repos[Project][hash[key]] }
          when :task_uuid    then { task:    repos[Task][hash[key]]    }
          else { key => hash[key] }
          end
        end
      end
    end

    def define_initialize_on new_class
      new_class.class_eval do
        def initialize args = {}
          @values = Hash[self.class.attrs.map do |attr, default|
            value = args.fetch attr do
              default.respond_to?(:call) ? default.call : default
            end
            [attr, value]
          end]
        end
      end
    end

    def define_eq_on new_class
      new_class.class_eval do
        def == other
          uuid == other.uuid
        end
      end
    end

    def define_to_h_on new_class
      new_class.class_eval do
        def to_h
          self.class.attrs.reduce({}) do |hash, (attr, _)|
            hash.merge to_h_mapping attr
          end
        end

        private

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

    def raises_from params
      Hash[params.map { |param| [param, -> { fail "#{param} required" }] }]
    end
  end
end end
