module Kamerling module Mapper
  module_function

  def from_h klass, hash
    hash = hash.merge addr: Addr[hash[:host], hash[:port], hash[:prot]]
    klass.new hash
  end

  def to_h object
    object.to_h.reduce({}) do |hash, (key, value)|
      hash.merge case key
                 when :addr    then value.to_h
                 when :client  then { client_uuid:  value.uuid }
                 when :project then { project_uuid: value.uuid }
                 when :task    then { task_uuid:    value.uuid }
                 else               { key => value }
                 end
    end
  end
end end
