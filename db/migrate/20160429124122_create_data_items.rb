class CreateDataItems < ActiveRecord::Migration[5.0]
  def change
    create_table :data_items do |t|
      t.jsonb :data, null: false
      t.string :typeid, null: false
      t.datetime :generated_at, null: false

      t.timestamps
    end
    add_index :data_items, :typeid
    add_index :data_items, :generated_at
  end
end
