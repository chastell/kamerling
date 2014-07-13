Sequel.migration do
  change do
    alter_table :results do
      add_column :received_at, :timestamp
    end
  end
end
