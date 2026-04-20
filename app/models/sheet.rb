# frozen_string_literal: true

class Sheet < ApplicationRecord
  has_many :reservations

  def sheet_str
    "#{row}-#{column}"
  end
end
