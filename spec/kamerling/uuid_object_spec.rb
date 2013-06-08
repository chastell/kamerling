require_relative '../spec_helper'

module Kamerling describe '.UUIDObject' do
  describe '.new' do
    it 'creates a class with an UUID property defaulting to a random UUID' do
      AttrLess = Kamerling.UUIDObject
      AttrLess.new.uuid.must_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
      AttrLess.new.uuid.wont_equal AttrLess.new.uuid
    end

    it 'allows setting custom properties and raises when they lack defaults' do
      FooFul = Kamerling.UUIDObject :foo
      FooFul.new(foo: 'bar').foo.must_equal 'bar'
      -> { FooFul.new }.must_raise RuntimeError
    end

    it 'allows setting properties’ default procs' do
      ProcFul = Kamerling.UUIDObject rand: -> { rand }
      ProcFul.new.rand.wont_equal ProcFul.new.rand
    end

    it 'allows setting properties’ default values' do
      ValFul = Kamerling.UUIDObject bar: :baz
      ValFul.new.bar.must_equal :baz
    end
  end

  describe '#==' do
    it 'reports UUID-based euqality' do
      Actor = Kamerling.UUIDObject :name
      Actor.new(name: :laurel).wont_equal Actor.new(name: :laurel)
      uuid = UUID.new
      Actor.new(name: :laurel, uuid: uuid)
        .must_equal Actor.new(name: :hardy, uuid: uuid)
    end
  end

  describe '#to_h' do
    it 'serialises the object to a Hash' do
      Hashable = Kamerling.UUIDObject :param
      Hashable.new(param: :val).to_h.must_equal({ param: :val, uuid: anything })
    end

    it 'serialises addr' do
      Addrble = Kamerling.UUIDObject :addr
      addrble = Addrble.new addr: Addr['127.0.0.1', 1981]
      addrble.to_h.must_equal({ host: '127.0.0.1', port: 1981, uuid: anything })
    end

    it 'serialises client' do
      Clientable = Kamerling.UUIDObject :client
      clientable = Clientable.new client: client = Client[addr: fake(:addr)]
      clientable.to_h.must_equal({ client_uuid: client.uuid, uuid: anything })
    end

    it 'serialises project' do
      Projable = Kamerling.UUIDObject :project
      projable = Projable.new project: project = Project[name: 'name']
      projable.to_h.must_equal({ project_uuid: project.uuid, uuid: anything })
    end

    it 'serialises task' do
      Tskble = Kamerling.UUIDObject :task
      tskble = Tskble.new task: task = Task[input: 'i', project: fake(:project)]
      tskble.to_h.must_equal({ task_uuid: task.uuid, uuid: anything })
    end
  end
end end
