module Kamerling
  Task = Struct.new :done, :input, :project, :uuid do
    def self.from_h hash, repos = Repos
      hash.merge! project: repos[Project][hash[:project_uuid]]
      hash.delete :project_uuid
      new hash
    end

    def initialize done: false, input: raise, project: raise, uuid: UUID.new
      super done, input, project, uuid
    end

    def to_h
      super.tap do |hash|
        hash.merge! project_uuid: project.uuid
        hash.delete :project
      end
    end
  end
end
