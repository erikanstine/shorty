class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links do |t|
      t.text :target_url
      t.string :code
      t.integer :clicks_count
      t.datetime :expires_at

      t.timestamps
    end
    add_index :links, :code
  end
end
