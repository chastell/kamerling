module Kamerling class Task < UUIDObject :input, :project, done: false
  def self.from_h hash, repos = Repos
    hash.merge! project: repos[Project][hash[:project_uuid]]
    hash.delete :project_uuid
    new hash
  end

  def to_h
    super.tap do |hash|
      hash.merge! project_uuid: project.uuid
      hash.delete :project
    end
  end
end end
