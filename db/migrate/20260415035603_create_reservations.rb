class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.date "date", null: false
      t.integer "schedule_id", limit: 8, null: false, index: true 
      t.integer "sheet_id", limit: 8, null: false, index: true 
      t.string "email", limit: 255, null: false
      t.string "name", limit: 50, null: false
      t.timestamps
    end

    add_index "reservations", ["date", "schedule_id", "sheet_id"], unique: true, name: "reservation_schedule_sheet_unique"

    add_foreign_key :reservations, :schedules,  column: "schedule_id"
    add_foreign_key :reservations, :sheets, column: "sheet_id"
  end
end
