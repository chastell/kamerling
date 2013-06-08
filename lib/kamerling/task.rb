module Kamerling class Task < UUIDObject :input, :project, done: false
  def self.from_h hash, repos = Repos
    hash.merge! project: repos[Project][hash[:project_uuid]]
    hash.delete :project_uuid
    new hash
  end
end end
