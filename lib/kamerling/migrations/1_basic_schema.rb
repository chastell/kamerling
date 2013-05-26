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
  end
end
