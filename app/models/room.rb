# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :site
  has_many :screens

  def screen_with_site
    "#{screen_number} (#{site&.name || 'UnKnown'})"
  end
end
