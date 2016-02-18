# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :clients do
      uuid    :uuid, primary_key: true
      boolean :busy, null: false
      inet    :host, null: false
      integer :port, null: false
      string  :prot, null: false
    end

    create_table :projects do
      uuid   :uuid, primary_key: true
      string :name, null: false
    end

    create_table :registrations do
      uuid    :uuid, primary_key: true
      inet    :host, null: false
      integer :port, null: false
      string  :prot, null: false
      foreign_key :client_uuid,  :clients,  index: true, null: false,
                                            type: :uuid
      foreign_key :project_uuid, :projects, index: true, null: false,
                                            type: :uuid
    end

    create_table :results do
      uuid    :uuid, primary_key: true
      bytea   :data, null: false
      inet    :host, null: false
      integer :port, null: false
      string  :prot, null: false
      foreign_key :client_uuid, :clients, index: true, null: false, type: :uuid
      foreign_key :task_uuid,   :tasks,   index: true, null: false, type: :uuid
    end

    create_table :tasks do
      uuid    :uuid, primary_key: true
      boolean :done, null: false
      bytea   :data, null: false
      foreign_key :project_uuid, :projects, index: true, null: false,
                                            type: :uuid
    end
  end
end
