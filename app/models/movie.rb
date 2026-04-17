class Movie < ApplicationRecord
  has_many :schedules
  validates :name, uniqueness: true
end
