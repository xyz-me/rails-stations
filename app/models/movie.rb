# frozen_string_literal: true

class Movie < ApplicationRecord
  has_many :schedules
  has_many :rankings
  validates :name, uniqueness: true
end
