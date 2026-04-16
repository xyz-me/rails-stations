class CreateSheetsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :sheets do |t|
      t.integer  "column", limit: 4, null: false
      t.string "row", limit: 1,  null: false
    end
  end
end
