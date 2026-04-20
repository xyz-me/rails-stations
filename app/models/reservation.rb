# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :schedule
  belongs_to :sheet
  validates :schedule_id, uniqueness: { scope: %i[sheet_id date], message: 'その座席はすでに予約済みです' }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX, message: 'の形式が正しくありません' }
end
