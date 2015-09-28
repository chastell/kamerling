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
      end
    end
  end
end
