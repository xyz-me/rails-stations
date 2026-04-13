class CreateMoviesDeleteIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :movies, :name
    add_index :movies, :name , unique: true
  end
end
