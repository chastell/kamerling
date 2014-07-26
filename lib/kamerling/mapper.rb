require_relative 'addr'

module Kamerling module Mapper
  module_function

  def from_h klass, hash, repos: Repos
    attributes = hash.map do |key, value|
      case key
      when :host, :port, :prot
        [:addr, Addr.new(hash)]
      when /_uuid$/
        type = key[/(.*)_uuid$/, 1].to_sym
        [type, repos[Kamerling.const_get(type.capitalize)][value]]
      else
        [key, value]
      end
    end.to_h
    klass.new attributes
  end

  def to_h object
    object.to_h.reduce({}) do |hash, (key, value)|
      hash.merge case value
                 when Addr then value.to_h
                 when Hash then { :"#{key}_uuid" => value[:uuid] }
                 else           { key => value }
                 end
    end
  end
end end
