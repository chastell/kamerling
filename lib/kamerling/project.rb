# frozen_string_literal: true

require_relative 'entity'

module Kamerling
  class Project < Entity
    attrs clients: Array, name: String, tasks: Array

    def new_to_h
      to_h.reject { |key, _| key == :clients or key == :tasks }
    end
  end
end
