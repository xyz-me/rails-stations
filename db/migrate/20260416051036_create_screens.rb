class CreateScreens < ActiveRecord::Migration[7.1]
  def change
    create_table :screens do |t|
      t.integer 'schedule_id', limit: 8, null: false
      t.integer 'screen_number', null: false
      t.timestamps
    end

    add_index :screens, :schedule_id, unique: true
    add_foreign_key :screens, :schedules, column: 'schedule_id'
  end
end
