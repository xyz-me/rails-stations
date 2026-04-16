class Screen < ApplicationRecord
  belongs_to :schedule
  validates :schedule_id, uniqueness: true
  VALID_NUMBER_REGEX = /\A[1-3]\z/
  validates :screen_number, presence: true, format: { with: VALID_NUMBER_REGEX, message: "の形式が正しくありません" }
end