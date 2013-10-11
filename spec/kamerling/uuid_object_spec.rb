require_relative '../spec_helper'

module Kamerling describe '.UUIDObject' do
  describe '.from_h' do
    it 'deserialises the object from a Hash' do
      Trivial = Kamerling.UUIDObject :question
      Trivial.from_h(question: :answer).question.must_equal :answer
    end

    it 'deserialises addr' do
      Netable = Kamerling.UUIDObject :addr
      Netable.from_h(host: '127.0.0.1', port: 1981, prot: :TCP).addr
        .must_equal Addr['127.0.0.1', 1981, :TCP]
    end

    it 'deserialises {client,project,task}_uuid' do
      client  = fake :client,  uuid: UUID.new
      project = fake :project, uuid: UUID.new
      task    = fake :task,    uuid: UUID.new
      Complete = Kamerling.UUIDObject :client, :project, :task
      repos = {
        Client  => { client.uuid  => client  },
        Project => { project.uuid => project },
        Task    => { task.uuid    => task    },
      }
      hash = { client_uuid: client.uuid, project_uuid: project.uuid,
        task_uuid: task.uuid, uuid: UUID.new }
      complete = Complete.from_h hash, repos: repos
      complete.client.must_equal  client
      complete.project.must_equal project
      complete.task.must_equal    task
    end
  end

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
      Actor.new(name: :laurel).wont_equal Actor.new name: :laurel
      uuid = UUID.new
      Actor.new(name: :laurel, uuid: uuid)
        .must_equal Actor.new name: :hardy, uuid: uuid
    end
  end

  describe '#to_h' do
    it 'serialises the object to a Hash' do
      Hashble = Kamerling.UUIDObject :param
      Hashble.new(param: :val).to_h.must_equal param: :val, uuid: anything
    end

    it 'serialises addr' do
      Addrble = Kamerling.UUIDObject :addr
      addrble = Addrble.new addr: Addr['127.0.0.1', 1981, :TCP]
      addrble.to_h.must_equal host: '127.0.0.1', port: 1981, prot: 'TCP',
        uuid: anything
    end

    it 'serialises client' do
      Clintable = Kamerling.UUIDObject :client
      clintable = Clintable.new client: client = Client.new(addr: fake(:addr))
      clintable.to_h.must_equal client_uuid: client.uuid, uuid: anything
    end

    it 'serialises project' do
      Projable = Kamerling.UUIDObject :project
      projable = Projable.new project: project = Project.new(name: 'name')
      projable.to_h.must_equal project_uuid: project.uuid, uuid: anything
    end

    it 'serialises task' do
      project = fake :project
      Tskble = Kamerling.UUIDObject :task
      tskble = Tskble.new task: task = Task.new(data: 'data', project: project)
      tskble.to_h.must_equal task_uuid: task.uuid, uuid: anything
    end
  end
end end
