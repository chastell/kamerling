module Kamerling module Messages class DATA < Message
  def self.[] client: raise, data: raise, project: raise, task: raise
    input = "DATA\0\0\0\0\0\0\0\0\0\0\0\0" + UUID.bin(client.uuid) +
      UUID.bin(project.uuid) + UUID.bin(task.uuid) + data
    new input
  end
end end end
