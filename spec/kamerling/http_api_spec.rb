require_relative '../spec_helper'

module Kamerling describe HTTPAPI do
  let(:app) { HTTPAPI }

  it 'serves root' do
    get '/'
    last_response.must_be :ok?
  end
end end
