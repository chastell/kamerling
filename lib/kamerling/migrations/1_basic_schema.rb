Sequel.migration do
  change do
    create_table :clients do
      uuid    :uuid, primary_key: true
      inet    :host, null: false
      integer :port, null: false
    end

    create_table :projects do
      uuid   :uuid, primary_key: true
      string :name, null: false
    end

    create_table :tasks do
      uuid  :uuid,  primary_key: true
      bytea :input, null: false
      foreign_key :project_uuid, :projects, index: true, null: false, type: :uuid
    end
  end
end
