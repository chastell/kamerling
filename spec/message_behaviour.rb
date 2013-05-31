module MessageBehaviour
  def self.included spec_class
    spec_class.class_eval do
      let(:cuuid) { '16B client  UUID' }
      let(:puuid) { '16B project UUID' }
      let(:tuuid) { '16B task    UUID' }
      let(:data)  { 'some-length data' }

      describe '#client_uuid' do
        it 'returns the client UUID' do
          mess.client_uuid.must_equal '31364220-636c-6965-6e74-202055554944'
        end
      end

      describe '#data' do
        it 'returns the result data' do
          mess.data.must_equal data
        end
      end

      describe '#project_uuid' do
        it 'returns the project UUID' do
          mess.project_uuid.must_equal '31364220-7072-6f6a-6563-742055554944'
        end
      end

      describe '#task_uuid' do
        it 'returns the task UUID' do
          mess.task_uuid.must_equal '31364220-7461-736b-2020-202055554944'
        end
      end

      describe '#type' do
        it 'returns the message type' do
          mess.type.must_match(/\A[A-Z]{4}\z/)
        end
      end
    end
  end
end
