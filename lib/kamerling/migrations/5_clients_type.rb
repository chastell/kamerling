Sequel.migration do
  change do
    alter_table :clients do
      add_column :type, :string
    end
  end
end
