Sequel.migration do
  change do
    create_table :dispatches do
      uuid      :uuid,          primary_key: true
      inet      :host,          null: false
      integer   :port,          null: false
      string    :prot,          null: false
      timestamp :dispatched_at, null: false
      foreign_key :client_uuid,  :clients,  index: true, null: false,
                                            type: :uuid
      foreign_key :project_uuid, :projects, index: true, null: false,
                                            type: :uuid
      foreign_key :task_uuid,    :tasks,    index: true, null: false,
                                            type: :uuid
    end
  end
end
