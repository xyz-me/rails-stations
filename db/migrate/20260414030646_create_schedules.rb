class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.integer "movie_id"  , limit: 8, null: false
      t.time "start_time" , null: false, comment: "上映開始時刻"
      t.time "end_time" , null: false, comment: "上映開始時刻"
      t.timestamps
    end
    add_foreign_key :schedules, :movies
  end
end
