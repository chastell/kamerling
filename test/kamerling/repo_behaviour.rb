# frozen_string_literal: true

module Kamerling
  module RepoBehaviour
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
          it 'returns the entity with the given id' do
            table.insert row
            _(repo.fetch('an id')).must_equal entity
          end

          it 'evaluates the block if the given id is missing' do
            evaluated = false
            repo.fetch('an id') { evaluated = true }
            assert evaluated
          end

          it 'raises NotFound if the id is missing and there is no block' do
            _(-> { repo.fetch('an id') }).must_raise Repo::NotFound
          end
        end
      end
    end
  end
end
