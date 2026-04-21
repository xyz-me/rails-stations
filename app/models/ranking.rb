# frozen_string_literal: true

class Ranking < ApplicationRecord
  belongs_to :movie
  validates :movie_id, uniqueness: { scope: %i[date], message: '重複データがあります' }
end
