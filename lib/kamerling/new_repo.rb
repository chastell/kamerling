require_relative 'mapper'

module Kamerling
  class NewRepo
    def fetch(uuid)
      Mapper.from_h(klass, table[uuid: uuid])
    end

    private

    private_attr_reader :klass
  end
end
