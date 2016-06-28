# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :dispatches do
      uuid      :id,            primary_key: true
      inet      :host,          null: false
      integer   :port,          null: false
      string    :prot,          null: false
      timestamp :dispatched_at, null: false
      foreign_key :client_id,  :clients,  index: true, null: false, type: :uuid
      foreign_key :project_id, :projects, index: true, null: false, type: :uuid
      foreign_key :task_id,    :tasks,    index: true, null: false, type: :uuid
    end
  end
end
