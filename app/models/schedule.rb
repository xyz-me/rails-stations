# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :movie
  has_many :reservations, dependent: :destroy
  has_one :screen

  def view_time
    "#{start_time.strftime('%H:%M')}-#{end_time.strftime('%H:%M')} (#{screen&.room&.site&.name || 'UnKnown'})"
  end

  def view_only_time
    "#{start_time.strftime('%H:%M')}-#{end_time.strftime('%H:%M')}"
  end

  # 形式 (YYYY:MM:DD HH:MM) の変換
  def start_time_fix
    return if start_time.blank?

    start_time.strftime('%Y-%m-%d %H:%M:%S')
  end

  def start_time_short
    return if start_time.blank?

    start_time.strftime('%H:%M:%S')
  end

  def end_time_fix
    return if end_time.blank?

    end_time.strftime('%Y-%m-%d %H:%M:%S')
  end

  def end_time_short
    return if end_time.blank?

    end_time.strftime('%H:%M:%S')
  end
end
