module MessageBehaviour
  def self.included spec_class
    spec_class.class_eval do
      describe '#client_uuid' do
        it 'returns the client UUID' do
          mess.client_uuid.must_equal '31364220-636c-6965-6e74-202055554944'
        end
      end

      describe '#payload' do
        it 'returns the result payload' do
          mess.payload.must_equal 'some payload'
        end
      end

      describe '#project_uuid' do
        it 'returns the project UUID' do
          mess.project_uuid.must_equal '31364220-7072-6f6a-6563-742055554944'
        end
      end

      describe '#raw' do
        it 'returns the raw bytes' do
          mess.raw.must_equal mess.type + "\0\0\0\0\0\0\0\0\0\0\0\0" +
            '16B client  UUID16B project UUID16B task    UUIDsome payload'
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
