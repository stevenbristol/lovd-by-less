ActiveRecord::Schema.define(:version => 1) do
  create_table :people do |t|
    t.column :name, :string
  end
end