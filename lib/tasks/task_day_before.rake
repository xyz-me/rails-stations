namespace :task_day_before do
  desc '前日メール配信'
  task send_email: :environment do
    tomorrow = Date.today + 1.day
    @reservations = Reservation.includes(schedule: %i[movie screen])
                               .where(date: tomorrow)
                               .where(movies: { is_showing: true })
                               .references(:movies)

    @reservations.each_with_index do |reservation, _i|
      # メール送信
      ReservationMailer.send_tomorrow(reservation).deliver
    end
  end
end
