Sequel.migration do
  change do
    alter_table :registrations do
      add_column :registered_at, :timestamp
    end
  end
end
