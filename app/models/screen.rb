# frozen_string_literal: true

class Screen < ApplicationRecord
  belongs_to :schedule
  validates :schedule_id, uniqueness: true
  belongs_to :room
end
