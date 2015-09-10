module Kamerling
  class RegistrationRepo
    def initialize(db)
      @table = db[:registrations]
    end

    def <<(registration)
      table << Mapper.to_h(registration)
    end

    private

    private_attr_reader :table
  end
end
