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
        end
      end
    end
  end
end
