module Kamerling
  Task = Struct.new :input, :project, :uuid do
    def initialize input: raise, project_uuid: nil,
      project: Repos[Project][project_uuid], uuid: raise
      super input, project, uuid
    end

    def to_h
      super.tap do |hash|
        hash.merge! project_uuid: project.uuid
        hash.delete :project
      end
    end
  end
end
