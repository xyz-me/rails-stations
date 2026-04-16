class Schedule < ApplicationRecord
  belongs_to :movie
  has_many :reservations

  def view_time
    self.start_time.strftime('%H:%M') + '-' + self.end_time.strftime('%H:%M')
  end

  
  # 形式 (YYYY:MM:DD HH:MM) の変換
  def start_time_fix
    return if start_time.blank?
    start_time.strftime("%Y-%m-%d %H:%M:%S")
  end

  
end