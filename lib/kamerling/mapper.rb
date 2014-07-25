require_relative 'addr'

module Kamerling module Mapper
  module_function

  def from_h klass, hash, repos: Repos
    attributes = hash.map do |key, value|
      case key
      when :host, :port, :prot then [:addr, Addr.new(hash)]
      when :project_uuid       then [:project, repos[Project][value]]
      else                          [key, value]
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
