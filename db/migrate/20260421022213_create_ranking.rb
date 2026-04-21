class CreateRanking < ActiveRecord::Migration[7.1]
  def change
    create_table :rankings do |t|
      t.integer 'movie_id', limit: 8, null: false
      t.date 'date', null: false
      t.integer 'count'
      t.timestamps
    end

    add_foreign_key :rankings, :movies
    add_index 'rankings', %w[movie_id date], unique: true, name: 'ranking_movie_id_date_unique'
  end
end
