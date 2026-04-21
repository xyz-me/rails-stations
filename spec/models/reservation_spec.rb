require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe '劇場の異なる同一条件の予約' do
    let(:movie) { create(:movie) }

    # 劇場1の設定
    let(:site_1) { create(:site, name: '映画館1') }
    let(:room_1) { create(:room, site: site_1, screen_number: 1) }

    # 劇場2の設定
    let(:site_2) { create(:site, name: '映画館2') }
    let(:room_2) { create(:room, site: site_2, screen_number: 1) }

    # 共通の座席とスケジュール
    let(:sheet) { create(:sheet, row: 'A', column: 1) }
    let(:schedule) { create(:schedule, movie: movie, start_time: '10:00', end_time: '12:00') }

    # スケジュールと各劇場の部屋を紐付け
    before do
      create(:screen, schedule: schedule, room: room_1)
    end

    it 'Siteが異なれば、同じ日付・スケジュール・座席で予約ができること' do
      # 予約1
      res1 = Reservation.create(
        date: Date.today,
        schedule: schedule,
        sheet: sheet,
        email: 'user1@example.com',
        name: 'ユーザー1'
      )
      expect(res1).to be_valid

      # 予約2
      schedule_2 = create(:schedule, movie: movie, start_time: '10:00', end_time: '12:00')
      create(:screen, schedule: schedule_2, room: room_2)

      res2 = Reservation.build(
        date: Date.today,
        schedule: schedule_2,
        sheet: sheet,
        email: 'user2@example.com',
        name: 'ユーザー2'
      )

      expect(res2).to be_valid
      expect { res2.save }.not_to raise_error
    end
  end
end
