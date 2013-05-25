Sequel.migration do
  change do
    create_table :clients do
      uuid :uuid, primary_key: true
    end
  end
end
