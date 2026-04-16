class Sheet < ApplicationRecord
  has_many :reservations

  def sheet_str
    row + "-" + column.to_s
  end
end