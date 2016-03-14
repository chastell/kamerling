# frozen_string_literal: true

module Kamerling
  module NewRepoBehaviour
    def self.included(spec_class)
      spec_class.class_eval do
        describe '#<<' do
          it 'adds a new entity to the repo' do
            assert table.empty?
            repo << entity
            _(table.first).must_equal row
          end
        end

        describe '#all' do
          it 'returns all of the entites' do
            table.insert row
            _(repo.all).must_equal [entity]
          end
        end

        describe '#fetch' do
          it 'returns the entity with the given UUID' do
            table.insert row
            _(repo.fetch('an UUID')).must_equal entity
          end

          it 'evaluates the block if the given UUID is missing' do
            evaluated = false
            repo.fetch('an UUID') { evaluated = true }
            assert evaluated
          end

          it 'raises NotFound if the UUID is missing and there is no block' do
            _(-> { repo.fetch('an UUID') }).must_raise NewRepo::NotFound
          end
        end
      end
    end
  end
end
