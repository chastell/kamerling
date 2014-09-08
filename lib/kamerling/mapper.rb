require_relative 'addr'

module Kamerling
  module Mapper
    module_function

    def from_h(klass, hash, repos: Repos)
      attributes = Hash[hash.map do |key, value|
        case key
        when :host, :port, :prot then [:addr, Addr.new(hash)]
        when /_uuid$/            then object_pair_from(key, value, repos)
        else                          [key, value]
        end
      end]
      klass.new(attributes)
    end

    def object_pair_from(key, value, repos)
      type = key[/(.*)_uuid$/, 1].to_sym
      [type, repos[Kamerling.const_get(type.capitalize)][value]]
    end

    def to_h(object)
      object.to_h.reduce({}) do |hash, (key, value)|
        hash.merge case value
                   when Addr then value.to_h
                   when Hash then { :"#{key}_uuid" => value[:uuid] }
                   else           { key => value }
                   end
      end
    end
  end
end
